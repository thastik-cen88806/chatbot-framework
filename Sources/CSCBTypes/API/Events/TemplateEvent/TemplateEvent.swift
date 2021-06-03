////
////  TemplateEvent
////  CSCBTypes
////
////  Created by ha100 on 05/20/2021.
////  Copyright © 2021 Ceska sporitelna. All rights reserved.
////
//
//import Foundation
//import Tagged
//
///// Template Event
/////
//public struct TemplateEvent: Codable {
//
//    // MARK: - TypeAliases
//
//    public typealias Message = GenericMessage<GenericAttachement<TemplateType, TemplatePayload>>
//    public typealias Timestamp = Tagged<Stamp, Int>
//
//    // MARK: - Types
//
//    enum CodingKeys: String, CodingKey {
//
//        case recipient
//        case message
//        case sender
//        case timestamp
//        case personaId = "persona_id"
//        case ownerAppId = "owner_app_id"
//        case persona
//    }
//
//    // MARK: - Properties
//
//    let recipient: Recipient
//    let message: Message
//
//    var sender: Sender?
//    var timestamp: Timestamp?
//    var personaId: String?
//    var ownerAppId: String?
//    var persona: Persona?
//
//    // MARK: - Init
//
//    /// Template Event
//    ///
//    /// - Parameters:
//    ///   - recipient: Recipient identifier (channel or user)
//    ///   - message: ??
//    ///   - sender: Sender object
//    ///   - timestamp: Event timestamp
//    ///   - personaId: ID of Identity to use as a sender
//    ///   - ownerAppId: Id of the application that is the owner of the thread. This property is
//    ///                 not sent or it is set to null if the recepient is the owner of the thread
//    ///   - persona: ??
//    ///
//    public init(recipient: Recipient,
//                message: Message,
//                sender: Sender?,
//                timestamp: Timestamp?,
//                personaId: String?,
//                ownerAppId: String?,
//                persona: Persona?) {
//
//        self.recipient = recipient
//        self.message = message
//
//        self.sender = sender
//        self.timestamp = timestamp
//        self.personaId = personaId
//        self.ownerAppId = ownerAppId
//        self.persona = persona
//    }
//}
