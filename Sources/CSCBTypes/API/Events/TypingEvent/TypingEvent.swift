//
//  TypingEvent
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Typing Event
///
///````javascript
/// {
///     "mid": "3WmQ032kXXJ7.e5932cce-0705-4261-9194-3bd482aba287.SZxw12p.746N30J",
///     "recipient": {
///         "id": "e5932cce-0705-4261-9194-3bd482aba287"
///     },
///     "sender": {
///         "id": "3WmQ032kXXJ7"
///     },
///     "sender_action": "typing_on",
///     "timestamp": 1623356876339
/// }
///````
///
public struct TypingEvent<R: TaggedType, S: TaggedType>: Codable where R: Codable, S: Codable, R.Tag: Identified, S.Tag: Identified {

    // MARK: - TypeAliases

    public typealias Timestamp = Tagged<Stamp, Int>

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case recipient
        case sender
        case timestamp
        case personaId = "persona_id"
        case ownerAppId = "owner_app_id"
        case persona
        case action = "sender_action"
    }

    // MARK: - Properties

    let recipient: Recipient<R>
    let action: TypingType

    var sender: Sender<S>?
    var timestamp: Timestamp?
    var personaId: String?
    var ownerAppId: String?
    var persona: Persona?

    // MARK: - Init

    /// Template Event
    ///
    /// - Parameters:
    ///   - recipient: Recipient identifier (channel or user)
    ///   - action: ??
    ///   - sender: Sender object
    ///   - timestamp: Event timestamp
    ///   - personaId: ID of Identity to use as a sender
    ///   - ownerAppId: Id of the application that is the owner of the thread. This property is
    ///                 not sent or it is set to null if the recepient is the owner of the thread
    ///   - persona: ??
    ///
    public init(recipient: Recipient<R>,
                action: TypingType,
                sender: Sender<S>?,
                timestamp: Timestamp?,
                personaId: String?,
                ownerAppId: String?,
                persona: Persona?) {

        self.recipient = recipient
        self.action = action

        self.sender = sender
        self.timestamp = timestamp
        self.personaId = personaId
        self.ownerAppId = ownerAppId
        self.persona = persona
    }
}
