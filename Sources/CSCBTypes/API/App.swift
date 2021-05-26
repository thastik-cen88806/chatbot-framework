//
//  App
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// App
///
public struct App: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case id
        case webhook
        case messages
        case msgPostbacks = "messaging_postbacks"
        case standby
        case msgHandovers = "messaging_handovers"
        case typing
        case readDelivery = "read_delivery"
        case parentAppid = "parent_app_id"
        case sharedContextUpdate = "shared_context_update"
    }

    // MARK: - Properties

    let id: String
    let webhook: String

    var messages: Bool?
    var msgPostbacks: Bool?
    var standby: Bool?
    var msgHandovers: Bool?
    var typing: Bool?
    var readDelivery: Bool?
    var parentAppid: String?
    var sharedContextUpdate: Bool?

    // MARK: - Init

    /// App
    ///
    /// - Parameters:
    ///   - id: Application identifier
    ///   - webhook: URL of the application webhook
    ///   - messages: Subscribe to messages
    ///   - msgPostbacks: Subscribe to messages
    ///   - standby: Subscribe to all messages
    ///   - msgHandovers: Subscribe to all messages
    ///   - typing: Subscribe to typing event
    ///   - readDelivery: Subscribe to read and delivery events
    ///   - parentAppid: Parent Application ID. Null for Master Application
    ///   - sharedContextUpdate: Subscribe for sharedContext changes
    ///
    public init(id: String,
                webhook: String,
                messages: Bool?,
                msgPostbacks: Bool?,
                standby: Bool?,
                msgHandovers: Bool?,
                typing: Bool?,
                readDelivery: Bool?,
                parentAppid: String?,
                sharedContextUpdate: Bool?) {

        self.id = id
        self.webhook = webhook
        self.messages = messages
        self.msgPostbacks = msgPostbacks
        self.standby = standby
        self.msgHandovers = msgHandovers

        self.typing = typing
        self.readDelivery = readDelivery
        self.standby = standby
        self.msgHandovers = msgHandovers
    }
}
