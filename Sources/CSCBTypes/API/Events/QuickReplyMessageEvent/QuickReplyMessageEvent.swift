////
////  QuickReplyMessageEvent
////  CSCBTypes
////
////  Created by ha100 on 05/20/2021.
////  Copyright © 2021 Ceska sporitelna. All rights reserved.
////
//
//import Foundation
//import Tagged
//
///// Quick Reply Message Event
/////
//public struct QuickReplyMessageEvent: Codable {
//
//    // MARK: - TypeAliases
//
//    public typealias Timestamp = Tagged<Stamp, Int>
//    public typealias IdentityID = Tagged<Identity, Int>
//    public typealias AppID = Tagged<App, String>
//
//
//    // MARK: - Types
//
//    enum CodingKeys: String, CodingKey {
//
//        case recipient
//        case sender
//        case timestamp
//        case personaId = "persona_id"
//        case ownerAppId = "owner_app_id"
//        case persona
//        case message
//    }
//
//    // MARK: - Properties
//
//    let recipient: Recipient
//    var message: String?
//
//    var sender: Sender?
//    var timestamp: Timestamp?
//    var personaId: IdentityID?
//    var ownerAppId: AppID?
//    var persona: Persona?
//
//    // MARK: - Init
//
//    /// Quick Reply Message Event
//    ///
//    /// - Parameters:
//    ///   - recipient: Recipient identifier (channel or user)
//    ///   - message: Developer defined payload
//    ///   - sender: Sender identifier (channel or user)
//    ///   - timestamp: Event timestamp
//    ///   - personaId: ID of Identity to use as a sender
//    ///   - ownerAppId: Id of the application that is the owner of the thread. This property is
//    ///                   not sent or it is set to null if the recepient is the owner of the thread
//    ///   - persona: ???
//    ///   - source: When the postback is issued as an interaction with button, this is a mid of the
//    ///             source event
//    ///   - context: sharedContext - example: OrderedMap { "webUserAgent": "Mozilla/5.0" }
//    ///
//    public init(recipient: Recipient,
//                postback: Postback,
//                sender: Sender?,
//                timestamp: Timestamp?,
//                personaId: IdentityID?,
//                ownerAppId: AppID?,
//                persona: Persona?,
//                source: String?,
//                context: Dictionary<String, String>?) {
//
//        self.recipient = recipient
//        self.postback = postback
//
//        self.sender = sender
//        self.timestamp = timestamp
//        self.personaId = personaId
//        self.ownerAppId = ownerAppId
//        self.persona = persona
//        self.source = source
//    }
//}
