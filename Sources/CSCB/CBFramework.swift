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

        static let url = "https://webchat.csast.csas.cz/"
        static let tokenUrl = "https://webchat.csast.csas.cz/api/frame?cid="
        static let referer = "https://www.csast.csas.cz"
        static let channelID = "e5932cce-0705-4261-9194-3bd482aba287"
    }

    // MARK: -- Properties

    public let tokenPublisher = PassthroughSubject<TokenZero, CBError>()

    var tokenCancellable: AnyCancellable?
    var eventCancellable: AnyCancellable?
    var messageCancellable: AnyCancellable?

    private let encoder = JSONEncoder()
    private let logger = Logger(label: "websocka")
    private var cookies: [HTTPCookie]?
    private let socket: CBEngine
    private var token: TokenZero?

    private var url: String {
        return "\(Key.url)?token=\(self.token?.jwt ?? "NA")"
    }

    // MARK: -- Init

    /// create the framework object
    ///
    /// - Note: the socket needs to be set before `setupBindings` is called
    ///
    public init() throws {

        self.socket = CBEngine(logger: self.logger)

        self.setupBindings()
        try self.updateToken()
    }

    deinit {

        self.tokenCancellable?.cancel()
        self.eventCancellable?.cancel()
        self.messageCancellable?.cancel()
        socket.disconnect()
    }

    // MARK: -- LifeCycle

    private func setupBindings() {

        self.tokenCancellable = tokenPublisher.sink(receiveCompletion: { _ in
            print(">>> finished")
        }, receiveValue: { [weak self] value in

            self?.logger.info("\(value)")
            self?.token = value
            try? self?.connectWebsocket()
        })

        self.eventCancellable = self.socket.eventPublisher.sink(receiveCompletion: { _ in
            print(">>> finished")
        }, receiveValue: { [weak self] event in

            self?.logger.info("\(event)")

            switch event {

                case .connected:

                    do {
                        try self?.setupConversation()
                    } catch {
                        self?.logger.error("setupConversation: \(error)")
                    }

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

        self.messageCancellable = self.socket.msgPublisher.sink(receiveCompletion: { _ in
            print(">>> finished")
        }, receiveValue: { [weak self] msg in

            self?.logger.info("\(msg)")
            print(msg)
        })
    }

    private func connectWebsocket() throws {

        self.logger.info("connect websocket")

        let request = try self.setupRequest(to: self.url)
        socket.start(request: request)
    }

    private func setupRequest(to urlString: String) throws -> URLRequest {

        guard let url = URL(string: urlString) else {

            self.logger.error("invalidUri: \(urlString)")
            throw CBError.invalidUri(url: urlString)
        }

        self.logger.info("request: \(url.absoluteString)")

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

        return request
    }

    private func setupConversation() throws {

        let channelID: Tagged<Channel, String> = "e5932cce-0705-4261-9194-3bd482aba287"

        guard let senderID = self.token?.userID else {

            self.logger.error("setupConversation senderID: \(self.token?.userID ?? "N/A")")
            return
        }

        let sender = Sender(id: senderID)
        let recipient = Recipient(id: channelID)

        let json = Init(recipient: recipient, sender: sender)
        let start = Start(recipient: recipient, sender: sender)

        self.send(.`init`(json))
        self.send(.start(start))
    }

    private func updateToken() throws {

        guard let tokenUrl = URL(string: "\(Key.tokenUrl)\(Key.channelID)") else {

            self.logger.error("invalidUri: \(Key.tokenUrl)\(Key.channelID)")
            throw CBError.invalidUri(url: "\(Key.tokenUrl)\(Key.channelID)")
        }

        self.getToken(from: tokenUrl)
    }

    /// obtain the token from the backend and extract it from received html (yaas HTML)
    ///
    /// - Parameter url: token provider `URL`
    ///
    private func getToken(from url: URL) {

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

    /// send specific `ChatMessage` to server
    ///
    /// - Note: `ChatMessage` is enum with limited scope of objects that we can send. They must be `Encodable` and so
    ///         we assume that this function will never fail
    ///
    /// - Parameter msg: `ChatMessage` object
    ///
    public func send(_ msg: ChatMessage) {

        do {

            let jsonData = try self.encoder.encode(msg)
            socket.write(data: jsonData)

        } catch {

            self.logger.critical("send: \(msg)")
        }
    }
}
