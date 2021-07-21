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

/// 
///
public class CBEngine: NSObject {

    // MARK: - Properties

    public let eventPublisher = PassthroughSubject<WebSocketEvent, CBError>()
    public let msgPublisher = PassthroughSubject<ChatMessage, CBError>()

    private var task: URLSessionWebSocketTask?
    private let logger: Logger

    // MARK: - Init

    public required init(logger: Logger) {

        self.logger = logger
    }

    // MARK: - Lifecycle

    public func start(request: URLRequest) {

        self.logger.info("start: \(request.url?.absoluteString ?? "NA")")

        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: nil)

        task = session.webSocketTask(with: request)
        doRead()
        task?.resume()
    }

    public func disconnect() {

        self.logger.info("disconnect")
        task?.cancel(with: URLSessionWebSocketTask.CloseCode.normalClosure, reason: nil)
    }

    public func stop(closeCode: UInt16) {

        self.logger.info("stop")
        let closeCode = URLSessionWebSocketTask.CloseCode(rawValue: Int(closeCode)) ?? .normalClosure
        task?.cancel(with: closeCode, reason: nil)
    }

    public func forceStop() {

        self.logger.info("forceStop")
        stop(closeCode: UInt16(URLSessionWebSocketTask.CloseCode.abnormalClosure.rawValue))
    }

    public func write(data: Data, opcode: FrameOpCode? = .textFrame) {

        switch opcode {

            case .binaryFrame:

                self.logger.info("write: \(data)")

                task?.send(.data(data)) { error in

                    guard let error = error else { return }

                    self.logger.error("binFrame \(error)")
                }

            case .textFrame:

                guard let text = String(data: data, encoding: .utf8) else {

                    self.logger.error("textFrame utf8 decode")
                    return
                }

                self.logger.info("write: \(text)")

                task?.send(.string(text)) { error in

                    guard let error = error else { return }

                    self.logger.error("textFrame \(error)")
                }


            case .ping:

                task?.sendPing { error in

                    guard let error = error else { return }

                    self.logger.error("ping \(error)")
                }

            default: self.logger.notice("opcode unhandled: \(String(describing: opcode))")
        }
    }

    private func doRead() {

        task?.receive { [weak self] result in

            switch result {

                case let .success(message):

                    switch message {

                        case let .string(string): self?.decodeMessage(msg: string)

                        case let .data(data): self?.eventPublisher.send(.binary(data))

                        @unknown default: self?.logger.notice("message unhandled: \(message)")
                    }

                case let .failure(error):

                    self?.logger.error("message \(error)")
                    self?.eventPublisher.send(.error(error))
            }

            self?.doRead()
        }
    }

    private func decodeMessage(msg: String) {

        if let obj = try? JSONDecoder().decode(ChatMessage.self, from: msg.data(using: .utf8) ?? Data()) {

            self.msgPublisher.send(obj)
        }
    }
}

extension CBEngine: URLSessionWebSocketDelegate {

    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didOpenWithProtocol protocol: String?) {

        self.eventPublisher.send(.connected)
    }

    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                           reason: Data?) {

        var r = ""

        if let d = reason {
            r = String(data: d, encoding: .utf8) ?? ""
        }

        self.eventPublisher.send(.disconnected(r, UInt16(closeCode.rawValue)))
    }
}
