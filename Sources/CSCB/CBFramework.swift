//
//  CBFramework
//  CSCB
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Combine
import CSCBTypes
import Foundation
import Tagged // should not be called from here
import Logging

public final class CBFramework {

    // MARK: -- Types

    private enum Key {

        static let referer = "https://www.csast.csas.cz"
        static let channelID = "e5932cce-0705-4261-9194-3bd482aba287"
    }

    // MARK: -- Properties

    public let tokenPublisher = PassthroughSubject<TokenZero, CBError>()

    var cancellable: AnyCancellable?
    var cancellable2: AnyCancellable?
    var cancellable3: AnyCancellable?

    private let encoder = JSONEncoder()
    private let logger = Logger(label: "websocka")
    private let _url: String
    private var cookies: [HTTPCookie]?
    private var socket: CBEngine?
    private var token: TokenZero?

    private var url: String {
        return "\(self._url)?token=\(self.token?.jwt ?? "NA")"
    }

    // MARK: -- Init

    /// create the framework object with connection created to specified `URL`
    ///
    /// - Parameter urlString: <#urlString description#>
    /// - Throws: <#description#>
    ///
    public init(url urlString: String) throws {

        self._url = urlString

        self.cancellable = tokenPublisher.sink(receiveCompletion: { _ in
            print(">>> finished")
        }, receiveValue: { [weak self] value in

            self?.logger.info("\(value)")
            self?.token = value
            try? self?.connect()
        })

        defer {

            self.updateToken()
        }
    }

    func connect() throws {

        guard let url = URL(string: self.url) else {

            self.logger.error("invalidUri: \(self.url)")
            throw CBError.invalidUri(url: self.url)
        }

        var request = URLRequest(url: url)
        request.addValue("webchat.csast.csas.cz", forHTTPHeaderField: "Host")
        request.addValue("https://webchat.csast.csas.cz", forHTTPHeaderField: "Origin")
        request.setValue(UserAgent.agent, forHTTPHeaderField: "User-Agent")

        HTTPCookieStorage.shared.setCookies(self.cookies ?? [],
                                            for: URL(string: "wss://webchat.csast.csas.cz/"),
                                            mainDocumentURL: nil)

        for cookie in self.cookies ?? [] {
            self.logger.info("cookie: \(cookie.name): \(cookie.value)")
        }

        self.logger.info("request: \(url.absoluteString)")
        socket = CBEngine(logger: self.logger)

        self.cancellable2 = self.socket?.eventPublisher.sink(receiveCompletion: { _ in
            print(">>> finished")
        }, receiveValue: { [weak self] event in

            switch event {

                case .connected: self?.startConversation()

                case .disconnected(_, _): self?.logger.info("disconnected")

                case .text(_): break

                case .binary(_): self?.logger.info("binary")

                case .pong(_): self?.logger.info("pong")

                case .ping(_): self?.logger.info("ping")

                case .error(_): self?.logger.info("error")

                case .viabilityChanged(_): self?.logger.info("visibility")

                case .reconnectSuggested(_): self?.logger.info("reconnect")

                case .cancelled: self?.logger.info("cancel")
            }
        })

        self.cancellable3 = self.socket?.msgPublisher.sink(receiveCompletion: { _ in
            print(">>> finished")
        }, receiveValue: { msg in

            print(msg)
        })

        socket?.start(request: request)
    }

    private func startConversation() {

        let channelID: Tagged<Channel, String> = "e5932cce-0705-4261-9194-3bd482aba287"

        guard let senderID = self.token?.userID else {

            self.logger.error("startConversation senderID: \(self.token?.userID ?? "N/A")")
            return
        }

        let sender = Sender(id: senderID)
        let recipient = Recipient(id: channelID)

        let json = Init(recipient: recipient, sender: sender)
        let start = Start(recipient: recipient, sender: sender)

        try? self.send(.`init`(json))
        try? self.send(.start(start))
    }

    func updateToken() {

        let tokenUrl = URL(string: "https://webchat.csast.csas.cz/api/frame?cid=\(Key.channelID)")!
        try? self.getToken(from: tokenUrl)
    }

    deinit {

        self.cancellable?.cancel()
        socket?.disconnect()
    }
    
    // MARK: -- LifeCycle

    func getToken(from url: URL) throws {

        self.logger.info("getToken")

        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        request.setValue(Key.referer, forHTTPHeaderField: "Referer")
        request.setValue(UserAgent.agent, forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data else {

                self.logger.error("tokenZero .tokenZeroNoHTMLData")
                self.tokenPublisher.send(completion: .failure(.tokenZeroNoHTMLData))
                return
            }

            guard let html = String(data: data, encoding: .utf8) else {

                self.logger.error("tokenZero .tokenZeroDataDecoding(data: \(data))")
                self.tokenPublisher.send(completion: .failure(.tokenZeroDataDecoding(data: data)))
                return
            }

            self.cookies = HTTPCookieStorage.shared.cookies(for: url)

            guard let token = try? html.decodeTokenZero() else {

                self.logger.error("tokenZero .tokenZeroHTMLExtract(error: \(html)")
                self.tokenPublisher.send(completion: .failure(.tokenZeroHTMLExtract(error: html)))
                return
            }

            self.tokenPublisher.send(token)

        }.resume()
    }

//    public func ping() {
//
//        var timestamp = Date.currentTimeStamp
//        let data = Data(bytes: &timestamp,
//                        count: MemoryLayout.size(ofValue: timestamp))
//        socket?.write(ping: data)
//    }

    public func send(_ msg: ChatMessage) throws {

        let jsonData = try self.encoder.encode(msg)

        socket?.write(data: jsonData)
    }
}
