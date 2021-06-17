//
//  TextMessageEvent
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Text Message Event
///
/// Example:
/// ========
///````javascript
///{
///  "recipient":{
///    "id":"<ID>"
///  },
///  "message":{
///    "text": "Here is a quick reply!"
///  }
///}
///````
///
public struct TextMessageEvent<R: TaggedType, S: TaggedType>: Codable where R: Codable, S: Codable, R.Tag: Identified, S.Tag: Identified, R: Equatable, S: Equatable {

    // MARK: - TypeAliases

    public typealias Timestamp = Tagged<Stamp, Int64>

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case recipient
        case sender
        case timestamp
        case message
        case appID = "app_id"
        case msgType = "messaging_type"
        case msgID = "mid"
    }

    // MARK: - Properties

    let recipient: Recipient<R>
    let message: TextMessage

    var sender: Sender<S>?
    var timestamp: Timestamp?
    var appID: String?
    var msgType: String?
    var msgID: String?

    // MARK: - Init

    /// Text Message Event
    ///
    /// - Parameters:
    ///   - recipient: Recipient identifier (channel or user)
    ///   - message: ???
    ///   - sender: Sender identifier (channel or user)
    ///   - timestamp: Event timestamp
    ///   - personaId: ID of Identity to use as a sender
    ///   - ownerAppId: Id of the application that is the owner of the thread. This property is
    ///                   not sent or it is set to null if the recepient is the owner of the thread
    ///   - persona: ???
    ///
    public init(recipient: Recipient<R>,
                message: TextMessage,
                sender: Sender<S>?,
                timestamp: Timestamp?,
                appID: String?,
                msgType: String?,
                msgID: String?) {

        self.recipient = recipient
        self.message = message
        
        self.sender = sender
        self.timestamp = timestamp
        self.appID = appID
        self.msgType = msgType
        self.msgID = msgID
    }
}

// MARK: - Debug

extension TextMessageEvent: CustomDebugStringConvertible {

    public var debugDescription: String {

        return "\(self.timestamp ?? 0) \(self.message.text)"
    }
}

extension TextMessageEvent: CustomStringConvertible {

    public var description: String {

        return self.debugDescription
    }
}

// MARK: - Equatability

extension TextMessageEvent: Equatable {}

public func == <R, S>(lhs: TextMessageEvent<R, S>, rhs: TextMessageEvent<R, S>) -> Bool {

    guard lhs.recipient == rhs.recipient,
          lhs.message == rhs.message,
          lhs.sender == rhs.sender,
          lhs.timestamp == rhs.timestamp,
          lhs.msgID == rhs.msgID,
          lhs.msgType == rhs.msgType,
          lhs.appID == rhs.appID else { return false }

    return true
}
