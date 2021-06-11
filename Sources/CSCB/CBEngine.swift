//
//  CBEngine
//  CSCB
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Logging

public enum WebSocketEvent {

    case connected([String: String])
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

public protocol EngineDelegate: AnyObject {
    func didReceive(event: WebSocketEvent)
}

public enum FrameOpCode: UInt8 {

    case continueFrame = 0x0
    case textFrame = 0x1
    case binaryFrame = 0x2
    // 3-7 are reserved.
    case connectionClose = 0x8
    case ping = 0x9
    case pong = 0xA
    // B-F reserved.
    case unknown = 100
}

public protocol Engine {
    
    func register(delegate: EngineDelegate)
    func start(request: URLRequest)
    func stop(closeCode: UInt16)
    func forceStop()
    func write(data: Data, opcode: FrameOpCode, completion: (() -> ())?)
    func write(string: String, completion: (() -> ())?)
}

public class CBEngine: NSObject, Engine, URLSessionDataDelegate, URLSessionWebSocketDelegate {

    private var task: URLSessionWebSocketTask?
    weak var delegate: EngineDelegate?
    var logger: Logger?

    public required init(logger: Logger) {

        self.logger = logger
    }

    public func register(delegate: EngineDelegate) {
        self.delegate = delegate
    }

    public func start(request: URLRequest) {

        self.logger?.info("start: \(request.url)")

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        task = session.webSocketTask(with: request)
        doRead()
        task?.resume()
    }

    public func disconnect() {

        self.logger?.info("disconnect")
        task?.cancel(with: URLSessionWebSocketTask.CloseCode.normalClosure, reason: nil)
    }

    public func stop(closeCode: UInt16) {

        print("stop")
        let closeCode = URLSessionWebSocketTask.CloseCode(rawValue: Int(closeCode)) ?? .normalClosure
        task?.cancel(with: closeCode, reason: nil)
    }

    public func forceStop() {

        print("forceStop")
        stop(closeCode: UInt16(URLSessionWebSocketTask.CloseCode.abnormalClosure.rawValue))
    }

    public func write(string: String, completion: (() -> ())?) {

        self.logger?.info("write: \(string)")

        task?.send(.string(string), completionHandler: { error in

            completion?()
        })
    }

    public func write(data: Data, opcode: FrameOpCode, completion: (() -> ())?) {

        self.logger?.info("write: \(data)")

        switch opcode {

            case .binaryFrame:

                task?.send(.data(data), completionHandler: { error in

                    print("engine write data response: \(error)")
                    completion?()
                })

            case .textFrame:

                let text = String(data: data, encoding: .utf8)!
                write(string: text, completion: completion)

            case .ping:

                task?.sendPing(pongReceiveHandler: { error in
                    completion?()
                })

            default: break //unsupported
        }
    }

    private func doRead() {

        task?.receive { [weak self] result in

            switch result {

                case let .success(message):

                    switch message {

                        case let .string(string): self?.broadcast(event: .text(string))

                        case let .data(data): self?.broadcast(event: .binary(data))

                        @unknown default: break
                    }

                case let .failure(error): self?.broadcast(event: .error(error))
            }

            self?.doRead()
        }
    }

    private func broadcast(event: WebSocketEvent) {

        delegate?.didReceive(event: event)
    }

    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didOpenWithProtocol protocol: String?) {

        let p = `protocol` ?? ""
        broadcast(event: .connected([CBHTTPWSHeader.protocolName: p]))
    }

    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                           reason: Data?) {

        var r = ""

        if let d = reason {
            r = String(data: d, encoding: .utf8) ?? ""
        }

        broadcast(event: .disconnected(r, UInt16(closeCode.rawValue)))
    }
}

public enum HTTPUpgradeError: Error {

    case notAnUpgrade(Int)
    case invalidData
}

public struct CBHTTPWSHeader {

    static let upgradeName        = "Upgrade"
    static let upgradeValue       = "websocket"
    static let hostName           = "Host"
    static let connectionName     = "Connection"
    static let connectionValue    = "Upgrade"
    static let protocolName       = "Sec-WebSocket-Protocol"
    static let versionName        = "Sec-WebSocket-Version"
    static let versionValue       = "13"
    static let extensionName      = "Sec-WebSocket-Extensions"
    static let keyName            = "Sec-WebSocket-Key"
    static let originName         = "Origin"
    static let acceptName         = "Sec-WebSocket-Accept"
    static let switchProtocolCode = 101
    static let defaultSSLSchemes  = ["wss", "https"]

    /// Creates a new URLRequest based off the source URLRequest.
    /// - Parameter request: the request to "upgrade" the WebSocket request by adding headers.
    /// - Parameter supportsCompression: set if the client support text compression.
    /// - Parameter secKeyName: the security key to use in the WebSocket request. https://tools.ietf.org/html/rfc6455#section-1.3
    /// - returns: A URLRequest request to be converted to data and sent to the server.
    ///
    public static func createUpgrade(request: URLRequest,
                                     supportsCompression: Bool,
                                     secKeyValue: String) -> URLRequest {

        guard let url = request.url, let parts = url.CBgetParts() else {
            return request
        }

        var req = request

        if request.value(forHTTPHeaderField: CBHTTPWSHeader.originName) == nil {
            var origin = url.absoluteString
            if let hostUrl = URL(string: "/", relativeTo: url) {
                origin = hostUrl.absoluteString
                origin.remove(at: origin.index(before: origin.endIndex))
            }
            req.setValue(origin, forHTTPHeaderField: CBHTTPWSHeader.originName)
        }
        req.setValue(CBHTTPWSHeader.upgradeValue, forHTTPHeaderField: CBHTTPWSHeader.upgradeName)
        req.setValue(CBHTTPWSHeader.connectionValue, forHTTPHeaderField: CBHTTPWSHeader.connectionName)
        req.setValue(CBHTTPWSHeader.versionValue, forHTTPHeaderField: CBHTTPWSHeader.versionName)
        req.setValue(secKeyValue, forHTTPHeaderField: CBHTTPWSHeader.keyName)

        if let cookies = HTTPCookieStorage.shared.cookies(for: url), !cookies.isEmpty {
            let headers = HTTPCookie.requestHeaderFields(with: cookies)
            for (key, val) in headers {
                req.setValue(val, forHTTPHeaderField: key)
            }
        }

        if supportsCompression {
            let val = "permessage-deflate; client_max_window_bits; server_max_window_bits=15"
            req.setValue(val, forHTTPHeaderField: CBHTTPWSHeader.extensionName)
        }
        let hostValue = req.allHTTPHeaderFields?[CBHTTPWSHeader.hostName] ?? "\(parts.host):\(parts.port)"
        req.setValue(hostValue, forHTTPHeaderField: CBHTTPWSHeader.hostName)
        return req
    }

    // generateWebSocketKey 16 random characters between a-z and return them as a base64 string
    public static func generateWebSocketKey() -> String {
        return Data((0..<16).map { _ in UInt8.random(in: 97...122) }).base64EncodedString()
    }
}

public enum HTTPEvent {
    case success([String: String])
    case failure(Error)
}

public protocol HTTPHandlerDelegate: AnyObject {
    func didReceiveHTTP(event: HTTPEvent)
}

public protocol HTTPHandler {
    func register(delegate: HTTPHandlerDelegate)
    func convert(request: URLRequest) -> Data
    func parse(data: Data) -> Int
}

public protocol HTTPServerDelegate: AnyObject {
    func didReceive(event: HTTPEvent)
}

public protocol HTTPServerHandler {
    func register(delegate: HTTPServerDelegate)
    func parse(data: Data)
    func createResponse(headers: [String: String]) -> Data
}

public struct CBURLParts {
    let port: Int
    let host: String
    let isTLS: Bool
}

public extension URL {

    /// isTLSScheme returns true if the scheme is https or wss
    var isTLSScheme: Bool {
        guard let scheme = self.scheme else {
            return false
        }
        return CBHTTPWSHeader.defaultSSLSchemes.contains(scheme)
    }

    /// getParts pulls host and port from the url.
    func CBgetParts() -> CBURLParts? {
        guard let host = self.host else {
            return nil // no host, this isn't a valid url
        }
        let isTLS = isTLSScheme
        var port = self.port ?? 0
        if self.port == nil {
            if isTLS {
                port = 443
            } else {
                port = 80
            }
        }
        return CBURLParts(port: port, host: host, isTLS: isTLS)
    }
}
