//
//  QuickReplyMessageEvent
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Quick Reply Message Event
///
/// Example:
/// ========
///````javascript
///{
///    "app_id": "cc_bot_master",
///    "message": {
///        "quick_replies": [
///            {
///                "content_type": "text",
///                "payload": "{\"action\":\"/Zasl\\u00e1n\\u00ed karty\",\"data\":{\"_ca\":\"/*\"}}",
///                "title": "Zasl\\u00e1n\\u00ed karty"
///            },
///            {
///                "content_type": "text",
///                "payload": "{\"action\":\"/Zm\\u011bna limit\\u016f ke kart\\u011b\",\"data\":{\"_ca\":\"/*\"}}",
///                "title": "Zm\\u011bna limit\\u016f ke kart\\u011b"
///            },
///            {
///                "content_type": "text",
///                "payload": "{\"action\":\"/D\\u00e9lka p\\u0159evodu\",\"data\":{\"_ca\":\"/*\"}}",
///                "title": "D\\u00e9lka p\\u0159evodu"
///            },
///            {
///                "content_type": "text",
///                "payload": "{\"action\":\"/Zm\\u011bna osobn\\u00edch \\u00fadaj\\u016f\",\"data\":{\"_ca\":\"/*\"}}",
///                "title": "Zm\\u011bna osobn\\u00edch \\u00fadaj\\u016f"
///            },
///            {
///                "content_type": "text",
///                "payload": "{\"action\":\"/Kde je sm\\u011bn\\u00e1rna\",\"data\":{\"_ca\":\"/*\"}}",
///                "title": "Kde je sm\\u011bn\\u00e1rna"
///            }
///        ],
///        "text": "S \\u010d\\u00edm V\\u00e1m m\\u016f\\u017eu poradit?"
///    },
///    "messaging_type": "RESPONSE",
///    "mid": "e5932cce-0705-4261-9194-3bd482aba287.3WmzFk1UY0vt.Sa408da.1X6N94S",
///    "recipient": {
///        "id": "3WmzFk1UY0vt"
///    },
///    "sender": {
///        "id": "e5932cce-0705-4261-9194-3bd482aba287"
///    },
///    "timestamp": 1623446516854
///}
///````
///
public struct QuickReplyMessageEvent<R: TaggedType, S: TaggedType>: Codable where R: Codable, S: Codable, R.Tag: Identified, S.Tag: Identified, R: Equatable, S: Equatable {

    // MARK: - TypeAliases

    public typealias Timestamp = Tagged<Stamp, Int>
    public typealias IdentityID = Tagged<Identity, Int>
    public typealias AppID = Tagged<App, String>


    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case recipient
        case sender
        case timestamp
        case appID = "app_id"
        case msgType = "messaging_type"
        case msgID = "mid"
        case message
    }

    // MARK: - Properties

    let recipient: Recipient<R>
    var message: QuickReplyMessage

    var sender: Sender<S>?
    var timestamp: Timestamp?
    var msgID: String?
    var msgType: String?
    var appID: String?

    // MARK: - Init

    /// Quick Reply Message Event
    ///
    /// - Parameters:
    ///   - recipient: Recipient identifier (channel or user)
    ///   - message: Developer defined payload
    ///   - sender: Sender identifier (channel or user)
    ///   - timestamp: Event timestamp
    ///   - personaId: ID of Identity to use as a sender
    ///   - ownerAppId: Id of the application that is the owner of the thread. This property is
    ///                   not sent or it is set to null if the recepient is the owner of the thread
    ///   - persona: ???
    ///   - source: When the postback is issued as an interaction with button, this is a mid of the
    ///             source event
    ///   - context: sharedContext - example: OrderedMap { "webUserAgent": "Mozilla/5.0" }
    ///
    public init(recipient: Recipient<R>,
                message: QuickReplyMessage,
                sender: Sender<S>?,
                timestamp: Timestamp?,
                msgID: String?,
                msgType: String?,
                appID: String?) {

        self.recipient = recipient
        self.message = message
        self.sender = sender
        self.timestamp = timestamp
        self.msgID = msgID
        self.msgType = msgType
        self.appID = appID
    }
}

// MARK: - Debug

extension QuickReplyMessageEvent: CustomDebugStringConvertible {

    public var debugDescription: String {

        return "\(self.timestamp ?? 0) \(self.message)"
    }
}

extension QuickReplyMessageEvent: CustomStringConvertible {

    public var description: String {

        return self.debugDescription
    }
}

// MARK: - Equatability

extension QuickReplyMessageEvent: Equatable {}

public func == <R, S>(lhs: QuickReplyMessageEvent<R, S>, rhs: QuickReplyMessageEvent<R, S>) -> Bool {

    guard lhs.recipient == rhs.recipient,
          lhs.message == rhs.message,
          lhs.sender == rhs.sender,
          lhs.timestamp == rhs.timestamp,
          lhs.msgID == rhs.msgID,
          lhs.msgType == rhs.msgType,
          lhs.appID == rhs.appID else { return false }

    return true
}
