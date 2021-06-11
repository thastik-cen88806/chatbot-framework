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

public final class CBFramework {

    // MARK: -- Properties

    private static let referer = "https://www.csast.csas.cz"
    private static let channelID = "e5932cce-0705-4261-9194-3bd482aba287"

    public let tokenPublisher: PassthroughSubject<TokenZero, CBError>
    var cancellable: AnyCancellable?

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

    private var socket: CBEngine?
    private let encoder = JSONEncoder()

    // MARK: -- Init
    
    ///    "http://localhost:8080"
    ///
    public init(url urlString: String) throws {

        self._url = urlString

        tokenPublisher = PassthroughSubject<TokenZero, CBError>()

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

        var request = URLRequest(url: url)
        request.addValue("webchat.csast.csas.cz", forHTTPHeaderField: "Host")
        request.addValue("https://webchat.csast.csas.cz", forHTTPHeaderField: "Origin")
        request.setValue(UserAgent.agent, forHTTPHeaderField: "User-Agent")

        HTTPCookieStorage.shared.setCookies(self.cookies ?? [],
                                            for: URL(string: "wss://webchat.csast.csas.cz/"),
                                            mainDocumentURL: nil)

        for cookie in self.cookies! {
            print(">>> cookie: \(cookie.name): \(cookie.value)")
        }

        print(">>> wss request: \(url.absoluteString)")

        socket = CBEngine()
        socket?.register(delegate: self)
        socket?.start(request: request)
    }

    func updateToken() {

        print(">>> token update")
        let tokenUrl = URL(string: "https://webchat.csast.csas.cz/api/frame?cid=\(CBFramework.channelID)")!
        try? self.getToken(from: tokenUrl)
    }

    deinit {

        self.cancellable?.cancel()
        socket?.disconnect()
    }
    
    // MARK: -- LifeCycle

    func getToken(from url: URL) throws {

        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        request.setValue(CBFramework.referer, forHTTPHeaderField: "Referer")
        request.setValue(UserAgent.agent, forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data else {

                self.tokenPublisher.send(completion: .failure(.tokenZeroNoHTMLData))
                return
            }

            guard let html = String(data: data, encoding: .utf8) else {

                self.tokenPublisher.send(completion: .failure(.tokenZeroDataDecoding(data: data)))
                return
            }

            self.cookies = HTTPCookieStorage.shared.cookies(for: url)

            guard let token = try? html.decodeTokenZero() else {

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

    public func send<T>(_ msg: T) throws where T: ChatMessage {

        let jsonData = try self.encoder.encode(msg)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        socket?.write(string: jsonString, completion: nil)
    }
}

extension CBFramework: EngineDelegate {

    public func didReceive(event: WebSocketEvent) {

        print(">>> wss engine didReceive: \(event)")
    }
}
