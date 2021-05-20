import Foundation
import Starscream

final class ChatbotFramework: WebSocketDelegate {
    
    // MARK: -- Types
    
    public enum CBError: Swift.Error {
        case invalidUri(url: String)
    }
    
    // MARK: -- Properties
    
    let subject: AnyPublisher<String, Never>
    var isConnected = false
    
    private var socket: WebSocket!
    private let server = WebSocketServer()
    
    // MARK: -- Init
    
    ///    "http://localhost:8080"
    ///
    public init(url urlString: String) throws {
        
        guard let url = URL(string: urlString) else {
            throw CBError.invalidUri(url: urlString)
        }
        
        self.init(url: url)
    }
    
    ///    "http://localhost:8080"
    ///
    public init(url: URL) {
        
        subject = PassthroughSubject<String, Never>()
        
        let pinner = FoundationSecurity(allowSelfSigned: true)
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request, certPinner: pinner)
        socket.delegate = self
        socket.connect()
    }
    
    
    deinit() {

        if isConnected {
            socket.disconnect()
        }
    }
    
    // MARK: -- LifeCycle
    
    public func ping() {
        socket.write(ping: Data())
    }
    
    public func write(text: String) {
        socket.write(string: text)
    }
    
    public func write(data: Data) {
        socket.write(data: data)
    }

    // MARK: -- Private
    
    private func set(value: String, forHeaderField named: String) {
        request.setValue(value, forHTTPHeaderField: named)
    }
        
    private func didReceive(event: WebSocketEvent, client: WebSocket) {
        
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
                
            case .error(let error):
                
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
