//
//  CBEngine
//  CSCB
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Combine
import CSCBTypes
import Foundation
import Logging

public enum WebSocketEvent {

    case connected
    case disconnected(String, UInt16)
    case text(String)
    case binary(Data)
    case pong(Data?)
    case ping(Data?)
    case error(Error?)
    case viabilityChanged(Bool)
    case reconnectSuggested(Bool)
    case cancelled
}

/// type of websocket frame to be sent
///
/// Note: - ranges 3-7 & B-F are reserved
///
public enum FrameOpCode: UInt8 {

    case continueFrame = 0x0
    case textFrame = 0x1
    case binaryFrame = 0x2
    case connectionClose = 0x8
    case ping = 0x9
    case pong = 0xA
    case unknown = 100
}

public class CBEngine: NSObject {

    // MARK: - Properties

    public let msgPublisher = PassthroughSubject<WebSocketEvent, CBError>()

    private var task: URLSessionWebSocketTask?
    private var logger: Logger?

    // MARK: - Init

    public required init(logger: Logger) {

        self.logger = logger
    }

    // MARK: - Lifecycle

    public func start(request: URLRequest) {

        self.logger?.info("start: \(request.url?.absoluteString ?? "NA")")

        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: nil)

        task = session.webSocketTask(with: request)
        doRead()
        task?.resume()
    }

    public func disconnect() {

        self.logger?.info("disconnect")
        task?.cancel(with: URLSessionWebSocketTask.CloseCode.normalClosure, reason: nil)
    }

    public func stop(closeCode: UInt16) {

        self.logger?.info("stop")
        let closeCode = URLSessionWebSocketTask.CloseCode(rawValue: Int(closeCode)) ?? .normalClosure
        task?.cancel(with: closeCode, reason: nil)
    }

    public func forceStop() {

        self.logger?.info("forceStop")
        stop(closeCode: UInt16(URLSessionWebSocketTask.CloseCode.abnormalClosure.rawValue))
    }

    public func write(data: Data, opcode: FrameOpCode? = .textFrame) {

        switch opcode {

            case .binaryFrame:

                self.logger?.info("write: \(data)")

                task?.send(.data(data)) { error in

                    guard let error = error else { return }
                    print(">>> ERROR binFrame \(error)")
                }

            case .textFrame:

                guard let text = String(data: data, encoding: .utf8) else {

                    print(">>> ERROR write utf8 decode")
                    return
                }

                self.logger?.info("write: \(text)")

                task?.send(.string(text)) { error in

                    guard let error = error else { return }
                    print(">>> ERROR write \(error)")
                }


            case .ping:

                task?.sendPing { error in

                    guard let error = error else { return }
                    print(">>> ERROR ping \(error)")
                }

            default: print(">>> UNHANDLED")
        }
    }

    private func doRead() {

        task?.receive { [weak self] result in

            switch result {

                case let .success(message):

                    switch message {

                        case let .string(string): self?.msgPublisher.send(.text(string)); self?.decodeMessage(msg: string)

                        case let .data(data): self?.msgPublisher.send(.binary(data))

                        @unknown default: print(">>> UNHANDLED")
                    }

                case let .failure(error): self?.msgPublisher.send(.error(error))
            }

            self?.doRead()
        }
    }

    private func decodeMessage(msg: String) {

        if let obj = try? JSONDecoder().decode(Object.self, from: msg.data(using: .utf8) ?? Data()) {
            print("\n\n\n\n\n=============================\n\n\n\n\(obj)")
        }
    }
}

extension CBEngine: URLSessionWebSocketDelegate {

    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didOpenWithProtocol protocol: String?) {

        self.msgPublisher.send(.connected)
    }

    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                           reason: Data?) {

        var r = ""

        if let d = reason {
            r = String(data: d, encoding: .utf8) ?? ""
        }

        self.msgPublisher.send(.disconnected(r, UInt16(closeCode.rawValue)))
    }
}
