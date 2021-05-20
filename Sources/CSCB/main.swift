//
//  CBFramework
//  ChatbotFramework
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Combine
import CSCBTypes
import Foundation

final class CBFramework {
    
    // MARK: -- Properties

    let subject: PassthroughSubject<String, Never>
    var isConnected = false

    private let socket: URLSessionWebSocketTask
    private let session: URLSession

    // MARK: -- Init
    
    ///    "http://localhost:8080"
    ///
    public convenience init(url urlString: String) throws {
        
        guard let url = URL(string: urlString) else {
            throw CBError.invalidUri(url: urlString)
        }
        
        self.init(url: url)
    }
    
    ///    "ws://localhost:8080/socket"
    ///
    public init(url: URL) {

        subject = PassthroughSubject<String, Never>()

        var request = URLRequest(url: url)
        request.timeoutInterval = 5

        self.session = URLSession(configuration: .default)
        self.socket = session.webSocketTask(with: url)
        self.listen()
        self.socket.resume()
    }


    deinit {

        if isConnected {

            self.socket.cancel(with: .goingAway, reason: nil)
        }
    }

    // MARK: -- LifeCycle

    func listen() {

      self.socket.receive { [weak self] result in

        guard let self = self else { return }

        switch result {

            case let .failure(error):

                self.isConnected = false
                self.handleError(error)

            case let .success(message):

                switch message {

                    case let .data(data):

                        print(">>> Received data: \(data.count)")

                    case let .string(string):

                        print(">>> Received text: \(string)")
                        self.subject.send(string)

                    @unknown default:
                        break
                }
        }

        self.listen()
      }
    }

    private func handleError(_ error: Error?) {

        if let e = error {

            print(">>> websocket encountered an error: \(e.localizedDescription)")

        } else {

            print(">>> websocket encountered an error")
        }
    }
}
