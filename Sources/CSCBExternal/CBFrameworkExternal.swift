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

public final class CBFrameworkExternal: WebSocketDelegate {

    // MARK: -- Properties
    
    public let subject: PassthroughSubject<String, Never>
//    let cancellable: AnyCancellable
    var isConnected = false
    
    private let socket: WebSocket
    private let server = WebSocketServer()
    
    // MARK: -- Init
    
    ///    "http://localhost:8080"
    ///
    public convenience init(url urlString: String) throws {
        
        guard let url = URL(string: urlString) else {
            throw CBError.invalidUri(url: urlString)
        }
        
        self.init(url: url)
    }
    
    ///    "http://localhost:8080"
    ///
    public init(url: URL) {

        subject = PassthroughSubject<String, Never>()
//        cancellable = subject

//        let pinner = FoundationSecurity(allowSelfSigned: true)
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5

//        socket = WebSocket(request: request, certPinner: pinner)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    
    deinit {

//        cancellable.cancel()
        
        if isConnected {
            socket.disconnect()
        }
    }
    
    // MARK: -- LifeCycle

    public func ping() {
        socket.write(ping: Data())
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
        socket.write(string: text)
    }

    private func write(data: Data) {
        socket.write(data: data)
    }

    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        
        switch event {
            
            case let .connected(headers):
                
                isConnected = true
                print(">>> websocket is connected: \(headers)")
                
            case .disconnected(let reason, let code):
                
                isConnected = false
                print(">>> websocket is disconnected: \(reason) with code: \(code)")
                
            case let .text(string):
                
                print(">>> Received text: \(string)")
                subject.send(string)
                
            case let .binary(data):
                
                print(">>> Received data: \(data.count)")
                
            case .ping(_):
                
                break
                
            case .pong(_):
                
                break
                
            case .viabilityChanged(_):
                
                break
                
            case .reconnectSuggested(_):
                
                break
                
            case .cancelled:
                
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
