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

struct NetworkTimeoutError: Error {
    let url: URL
}

public final class CBFrameworkExternal: WebSocketDelegate {

    // MARK: -- Properties
    
    public let tokenPublisher: PassthroughSubject<TokenZero, Never>
    var cancellable: AnyCancellable?
    var isConnected = false

    public var token: TokenZero? {
        didSet {
            try? self.connect()
        }
    }

    private var url: String {
        return "https://webchat.csast.csas.cz/?token=\(self.token?.jwt ?? "NA")"
    }
    private let _url: String

    var cookies: [HTTPCookie]?

    private var socket: WebSocket?
    private let server = WebSocketServer()
    
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

        var request = URLRequest(url: url)
        request.addValue("webchat.csast.csas.cz", forHTTPHeaderField: "Host")
        request.addValue("https://webchat.csast.csas.cz", forHTTPHeaderField: "Origin")

//        request.setValue("__exponea_etc__=a129e807-83c4-42f1-82e1-196dc80bfd5b; _gcl_au=1.1.1385879975.1619435227; _cs_c=1; _ga=GA1.2.214172330.1619435229; _fbp=fb.1.1619435228774.124321229; aam_exponea=segs%3D12209348; aam_uuid=56360206856827211261081624787637237117; csasauxid=gEHrq8Y3LSJOq1sUwHfFBLqT8i0LJUUiKcchNSpJrg8zhA8vUN%2F2rwE5hip74pxh3ZAhwkWa1o9iNqALC%2BlHHlmwO4Dh5JuECfJYrgsIdaE%3D#MEP#1619436430249; _cs_cvars=%7B%221%22%3A%5B%22Page%20Name%22%2C%22george%22%5D%2C%222%22%3A%5B%22Page%20Title%22%2C%22George.%20Bankovnictv%C3%AD%20budoucnosti%2C%20kter%C3%A9%20usnad%C5%88uje%20%C5%BEivot%20%7C%20%C4%8Cesk%C3%A1%20spo%C5%99itelna%22%5D%2C%223%22%3A%5B%22Page%20Template%22%2C%22standardContentPage%22%5D%2C%224%22%3A%5B%22Language%22%2C%22cs%22%5D%7D; _cs_id=520c34c7-1434-ae61-88a7-0de4f9dfb78b.1619435227.2.1620807918.1620807918.1.1653599227612.Lax.0; __CT_Data=gpv=3&ckp=tld&dm=csas.cz&apv_57_www56=3&cpv_57_www56=3; AMCVS_FE1920AE5B7C26720A495D34%40AdobeOrg=1; AMCV_FE1920AE5B7C26720A495D34%40AdobeOrg=-330454231%7CMCMID%7C56749854075694931941149552436431866065%7CMCAAMLH-1621412720%7C6%7CMCAAMB-1621412720%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1620815120s%7CNONE%7CvVersion%7C3.1.2%7CMCCIDH%7C-1879704833; _wcc_=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0IjoiYiIsImJpZCI6IjZmeTBTWGtsVmVQIiwiaWF0IjoxNjIxMzMwMDE0fQ.ab3cSfjZx8OlKIC-t2Y5CIdwLC4XCeaVBaWnBMjhHFg; ARRAffinity=7f12b21206fd37e983e9c7f2cadafff0f471663a0688801c9d593a9db00203cf; ARRAffinitySameSite=7f12b21206fd37e983e9c7f2cadafff0f471663a0688801c9d593a9db00203cf; _wcc_e5932cce0705426191943bd482aba287=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0IjoiYyIsImJpZCI6IjZmeTBTWGtsVmVQIiwidWlkIjoiM1drMTF1MkRHc3R3IiwiY2lkIjoiZTU5MzJjY2UtMDcwNS00MjYxLTkxOTQtM2JkNDgyYWJhMjg3Iiwib3BlbiI6dHJ1ZSwiaWF0IjoxNjIyNjgxOTYxLCJleHAiOjE2MjI2ODU1NjF9.X90QbYPPKTm_nroMv46sVYDD8-ZwbFgHjJ1w-FYDzeo", forHTTPHeaderField: " Cookie")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("text/html,application/xhtml+xml,application/xml", forHTTPHeaderField: "Accept")

        request.setValue("keep-alive", forHTTPHeaderField: "connection")

        request.setValue("en-GB,en;q=0.9,en-US;q=0.8,cs;q=0.7", forHTTPHeaderField: "Accept-Language")
        request.setValue("permessage-deflate; client_max_window_bits", forHTTPHeaderField: "Sec-WebSocket-Extensions")
//        request.setValue("13", forHTTPHeaderField: "Sec-WebSocket-Version")
//        request.setValue("websocket", forHTTPHeaderField: "Upgrade")
        request.setValue("chat,superchat", forHTTPHeaderField: "Sec-WebSocket-Protocol")
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36", forHTTPHeaderField: "User-Agent")


//        request.setValue("chat,superchat", forHTTPHeaderField: "Sec-WebSocket-Protocol")
        request.timeoutInterval = 5

        HTTPCookieStorage.shared.setCookies(self.cookies ?? [], for: url, mainDocumentURL: nil)
        for cookie in self.cookies! {
            var cookieProperties = [HTTPCookiePropertyKey: Any]()
            cookieProperties[.name] = cookie.name
            cookieProperties[.value] = cookie.value
            cookieProperties[.domain] = cookie.domain
            cookieProperties[.path] = cookie.path
            cookieProperties[.version] = cookie.version
            cookieProperties[.expires] = Date().addingTimeInterval(31536000)

            let newCookie = HTTPCookie(properties: cookieProperties)
            HTTPCookieStorage.shared.setCookie(newCookie!)

            print(">>> cookie: \(cookie.name) value: \(cookie.value)")
        }

//        let jar = HTTPCookieStorage.shared
//        let cookieHeaderField = ["Set-Cookie": "__exponea_etc__=a129e807-83c4-42f1-82e1-196dc80bfd5b; _gcl_au=1.1.1385879975.1619435227; _cs_c=1; _ga=GA1.2.214172330.1619435229; _fbp=fb.1.1619435228774.124321229; aam_exponea=segs%3D12209348; aam_uuid=56360206856827211261081624787637237117; csasauxid=gEHrq8Y3LSJOq1sUwHfFBLqT8i0LJUUiKcchNSpJrg8zhA8vUN%2F2rwE5hip74pxh3ZAhwkWa1o9iNqALC%2BlHHlmwO4Dh5JuECfJYrgsIdaE%3D#MEP#1619436430249; _cs_cvars=%7B%221%22%3A%5B%22Page%20Name%22%2C%22george%22%5D%2C%222%22%3A%5B%22Page%20Title%22%2C%22George.%20Bankovnictv%C3%AD%20budoucnosti%2C%20kter%C3%A9%20usnad%C5%88uje%20%C5%BEivot%20%7C%20%C4%8Cesk%C3%A1%20spo%C5%99itelna%22%5D%2C%223%22%3A%5B%22Page%20Template%22%2C%22standardContentPage%22%5D%2C%224%22%3A%5B%22Language%22%2C%22cs%22%5D%7D; _cs_id=520c34c7-1434-ae61-88a7-0de4f9dfb78b.1619435227.2.1620807918.1620807918.1.1653599227612.Lax.0; __CT_Data=gpv=3&ckp=tld&dm=csas.cz&apv_57_www56=3&cpv_57_www56=3; AMCVS_FE1920AE5B7C26720A495D34%40AdobeOrg=1; AMCV_FE1920AE5B7C26720A495D34%40AdobeOrg=-330454231%7CMCMID%7C56749854075694931941149552436431866065%7CMCAAMLH-1621412720%7C6%7CMCAAMB-1621412720%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1620815120s%7CNONE%7CvVersion%7C3.1.2%7CMCCIDH%7C-1879704833; _wcc_=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0IjoiYiIsImJpZCI6IjZmeTBTWGtsVmVQIiwiaWF0IjoxNjIxMzMwMDE0fQ.ab3cSfjZx8OlKIC-t2Y5CIdwLC4XCeaVBaWnBMjhHFg; ARRAffinity=7f12b21206fd37e983e9c7f2cadafff0f471663a0688801c9d593a9db00203cf; ARRAffinitySameSite=7f12b21206fd37e983e9c7f2cadafff0f471663a0688801c9d593a9db00203cf; _wcc_e5932cce0705426191943bd482aba287=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0IjoiYyIsImJpZCI6IjZmeTBTWGtsVmVQIiwidWlkIjoiM1drMTF1MkRHc3R3IiwiY2lkIjoiZTU5MzJjY2UtMDcwNS00MjYxLTkxOTQtM2JkNDgyYWJhMjg3Iiwib3BlbiI6dHJ1ZSwiaWF0IjoxNjIyNjgxOTYxLCJleHAiOjE2MjI2ODU1NjF9.X90QbYPPKTm_nroMv46sVYDD8-ZwbFgHjJ1w-FYDzeo"]
//        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url)
//        jar.setCookies(cookies, for: url, mainDocumentURL: url)


        let compression = WSCompression()
        socket = WebSocket(request: request, compressionHandler: compression)
//        socket = WebSocket(request: request, certPinner: pinner)
//        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
        print(">>> sockeeet: \(url.absoluteString)")
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

        var request = URLRequest(url: url)
        request.addValue("https://www.csast.csas.cz", forHTTPHeaderField: "Referer")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/xml", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data,
                  let html = String(data: data, encoding: .utf8),
                  let httpResponse = response as? HTTPURLResponse,
                  let fields = httpResponse.allHeaderFields as? [String: String] else {

                print(">>> err: \(error?.localizedDescription ?? "NA") resp: \(response)")
                return
            }

            self.cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)

            let jsonWhiteSpace = "\\s"
            let jsonPattern = "\\{(.*)\\}"

            struct TokenZeroHTMLExtractError: Error {
                let error: String
            }

            let token = html
                .replacingOccurrences(of: jsonWhiteSpace, with: "", options: .regularExpression)
                .match(regex: jsonPattern)?
                .data(using: .utf8)?
                .decode(to: TokenZero.self) ?? Result.failure(TokenZeroHTMLExtractError(error: html))

            self.tokenPublisher.send(try! token.get())

        }.resume()
    }

    public func ping() {
        socket?.write(ping: Data())
    }

    public func send(_ msg: CBMessage) {

        switch msg {

            case let .text(text): self.write(text: text)

            case let .data(data): self.write(data: data)
        }
    }

    // MARK: -- Private
    
//    private func set(value: String, forHeaderField named: String) {
//        request.setValue(value, forHTTPHeaderField: named)
//    }

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
