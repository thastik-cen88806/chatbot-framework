//
//  CBFrameworkExternal
//  ChatbotFrameworkExternal
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Combine
import CSCBTypes
import Foundation
import Starscream
import Tagged

public final class CBFrameworkExternal: WebSocketDelegate {

    // MARK: -- Properties

    private static let referer = "https://www.csast.csas.cz"

    public let tokenPublisher: PassthroughSubject<TokenZero, Never>
    var cancellable: AnyCancellable?
    var isConnected = false

    public var token: TokenZero? {
        didSet {
            try? self.connect()
        }
    }

    private var url: String {
        return "wss://webchat.csast.csas.cz/?token=\(self.token?.jwt ?? "NA")"
    }
    private let _url: String

    var cookies: [HTTPCookie]?

    private var socket: WebSocket?
    private let server = WebSocketServer()
    private let encoder = JSONEncoder()

    // MARK: -- Init
    
    ///    "http://localhost:8080"
    ///
    public init(url urlString: String) throws {

        self._url = urlString

        tokenPublisher = PassthroughSubject<TokenZero, Never>()

//        let pinner = FoundationSecurity(allowSelfSigned: true)

        self.cancellable = tokenPublisher.sink(receiveCompletion: { _ in
            print(">>> finished")
        }, receiveValue: { [weak self] value in

            print(">>> token: \(value)")
            self?.token = value
        })

        defer {

            self.updateToken()
        }
    }

    func connect() throws {

        guard let url = URL(string: self.url) else {

            print(">>> eeeeeeeeeee")
            throw CBError.invalidUri(url: self.url)
        }

        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.addValue("webchat.csast.csas.cz", forHTTPHeaderField: "Host")
        request.addValue("https://webchat.csast.csas.cz", forHTTPHeaderField: "Origin")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Authorization")
//        request.setValue("keep-alive", forHTTPHeaderField: "connection")
//        request.setValue("en-GB,en;q=0.9,en-US;q=0.8,cs;q=0.7", forHTTPHeaderField: "Accept-Language")
//        request.setValue("permessage-deflate; client_max_window_bits", forHTTPHeaderField: "Sec-WebSocket-Extensions")
//        request.setValue("13", forHTTPHeaderField: "Sec-WebSocket-Version")
//        request.setValue("websocket", forHTTPHeaderField: "Upgrade")
//        request.setValue("chat,superchat", forHTTPHeaderField: "Sec-WebSocket-Protocol")
        request.setValue(UserAgent.agent, forHTTPHeaderField: "User-Agent")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")

//        request.setValue("chat,superchat", forHTTPHeaderField: "Sec-WebSocket-Protocol")
//        request.timeoutInterval = 5

        HTTPCookieStorage.shared.setCookies(self.cookies ?? [], for: URL(string: "wss://webchat.csast.csas.cz/"), mainDocumentURL: nil)

        for cookie in self.cookies! {
//
//            var cookieProperties = [HTTPCookiePropertyKey: Any]()
//            cookieProperties[.name] = cookie.name
//            cookieProperties[.value] = cookie.value
//            cookieProperties[.domain] = cookie.domain
//            cookieProperties[.path] = cookie.path
//            cookieProperties[.version] = cookie.version
//            cookieProperties[.expires] = Date().addingTimeInterval(31536000)
//
//            let newCookie = HTTPCookie(properties: cookieProperties)
//            HTTPCookieStorage.shared.setCookie(cookie)

            print(">>> cookie: \(cookie.name): \(cookie.value)")
        }

        print(">>> sockeeet: \(url.absoluteString)")

//        let compression = WSCompression()
//        socket = WebSocket(request: request, compressionHandler: compression)
//        socket = WebSocket(request: request, certPinner: pinner)
        let engine = CBEngine()
        engine.register(delegate: self)
        socket = WebSocket(request: request, engine: engine)
        socket?.delegate = self
        socket?.connect()
    }

    func updateToken() {

        print(">>> token update")
        let channelID = Tagged<Channel, String>(rawValue: "e5932cce-0705-4261-9194-3bd482aba287")
        let tokenUrl = URL(string: "https://webchat.csast.csas.cz/api/frame?cid=\(channelID)")!
        self.downloadHTML(from: tokenUrl)
    }

    deinit {

        self.cancellable?.cancel()
        
        if isConnected {
            socket?.disconnect()
        }
    }
    
    // MARK: -- LifeCycle

    func downloadHTML(from url: URL) {

        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        request.setValue(CBFrameworkExternal.referer, forHTTPHeaderField: "Referer")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserAgent.agent, forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data else {

//                CBError.tokenZeroNoHTMLData
                return
            }

            guard let html = String(data: data, encoding: .utf8) else {

//                CBError.tokenZeroHTMLExtract(error: String)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  let fields = httpResponse.allHeaderFields as? [String: String] else {

//                CBError.tokenZeroNoCookies(response: response)
                return
            }

            let cookieStorage = HTTPCookieStorage.shared
            self.cookies = cookieStorage.cookies(for: url)

            let jsonWhiteSpace = "\\s"
            let jsonPattern = "\\{(.*)\\}"

            // losing error context
            let result = try? html
                .replacingOccurrences(of: jsonWhiteSpace, with: "", options: .regularExpression)
                .match(regex: jsonPattern)
                .data(using: .utf8)?
                .decode(to: TokenZero.self) ?? Result.failure(CBError.tokenZeroHTMLExtract(error: html))

            switch result {

                case let .success(token): self.tokenPublisher.send(token)

                case let .failure(error): print(">>> sink \(error)")

                case .none: break // Result.failure(CBError.tokenZeroHTMLExtract(error: html))

            }
        }.resume()
    }

    public func ping() {
        socket?.write(ping: Data())
    }

    public func send<T>(_ msg: T) throws where T: ChatMessage {

        let data = try self.encoder.encode(msg)

        self.write(data: data)
    }

    // MARK: -- Private
    
    private func write(text: String) {
        socket?.write(string: text)
    }

    private func write(data: Data) {
        socket?.write(data: data)
    }

    public func didReceive(event: WebSocketEvent, client: WebSocket) {

        print(">>> wss didReceive")

        switch event {

            case let .connected(headers):

                isConnected = true
                print(">>> websocket is connected: \(headers)")

            case .disconnected(let reason, let code):

                isConnected = false
                print(">>> websocket is disconnected: \(reason) with code: \(code)")

            case let .text(string):

                print(">>> Received text: \(string)")
//                subject.send(string)

            case let .binary(data):

                print(">>> Received data: \(data.count)")

            case .ping(_):

                print(">>> wss received ping")

            case .pong(_):

                print(">>> wss received pong")

            case .viabilityChanged(_):

                break

            case .reconnectSuggested(_):

                break

            case .cancelled:

                print(">>> wss cancelled")
                isConnected = false

            case let .error(error):

                isConnected = false
                handleError(error)
        }
    }
    
    private func handleError(_ error: Error?) {
        
        if let e = error as? WSError {
            
            print(">>> websocket encountered an error: \(e.message)")
            
        } else if let e = error {
            
            print(">>> websocket encountered an error: \(e.localizedDescription)")
            
        } else {
            
            print(">>> websocket encountered an error")
        }
    }
}

extension CBFrameworkExternal: EngineDelegate {

    public func didReceive(event: WebSocketEvent) {

        print(">>> wss engine didReceive: \(event)")
    }
}
