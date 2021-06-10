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
///    "text": "Here is a quick reply!",
///    "quick_replies":[
///      {
///        "content_type":"text",
///        "title":"Search",
///        "payload":"<POSTBACK_PAYLOAD>"
///      }
///    ]
///  }
///}
///````
///
public struct TextMessageEvent<T: TaggedType>: Codable where T: Codable, T.Tag: Identified {

    // MARK: - TypeAliases

    public typealias Timestamp = Tagged<Stamp, Int64>

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case recipient
        case sender
        case timestamp
        case personaId = "persona_id"
        case ownerAppId = "owner_app_id"
        case persona
        case message
    }

    // MARK: - Properties

    let recipient: Recipient<T>
    let message: TextMessage

    var sender: Sender<T>?
    var timestamp: Timestamp?
    var personaId: String?
    var ownerAppId: String?
    var persona: Persona?

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
    public init(recipient: Recipient<T>,
                message: TextMessage,
                sender: Sender<T>?,
                timestamp: Timestamp?,
                personaId: String?,
                ownerAppId: String?,
                persona: Persona?) {

        self.recipient = recipient
        self.message = message
        
        self.sender = sender
        self.timestamp = timestamp
        self.personaId = personaId
        self.ownerAppId = ownerAppId
        self.persona = persona
    }
}
