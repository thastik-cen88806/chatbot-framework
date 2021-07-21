////
////  TakeThreadEvent
////  CSCBTypes
////
////  Created by ha100 on 05/20/2021.
////  Copyright © 2021 Ceska sporitelna. All rights reserved.
////
//
//import Foundation
//import Tagged
//
///// Take Thread Event
/////
//public struct TakeThreadEvent: Codable {
//
//    // MARK: - TypeAliases
//
//    public typealias Timestamp = Tagged<Stamp, Int>
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
//        case thread = "take_thread_control"
//    }
//
//    // MARK: - Properties
//
//    let recipient: Recipient
//    let thread: ThreadTakeover
//
//    var sender: Sender?
//    var timestamp: Timestamp?
//    var personaId: String?
//    var ownerAppId: String?
//    var persona: Persona?
//
//    // MARK: - Init
//
//    /// Take Thread Event
//    ///
//    /// - Parameters:
//    ///   - recipient: Recipient identifier (channel or user)
//    ///   - thread: ???
//    ///   - sender: Sender identifier (channel or user)
//    ///   - timestamp: Event timestamp
//    ///   - personaId: ID of Identity to use as a sender
//    ///   - ownerAppId: Id of the application that is the owner of the thread. This property is
//    ///                   not sent or it is set to null if the recepient is the owner of the thread
//    ///   - persona: ???
//    ///
//    public init(recipient: Recipient,
//                thread: ThreadTakeover,
//                sender: Sender?,
//                timestamp: Timestamp?,
//                personaId: String?,
//                ownerAppId: String?,
//                persona: Persona?) {
//
//        self.recipient = recipient
//        self.thread = thread
//        
//        self.sender = sender
//        self.timestamp = timestamp
//        self.personaId = personaId
//        self.ownerAppId = ownerAppId
//        self.persona = persona
//    }
//}
