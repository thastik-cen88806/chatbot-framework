//
//  TextMessage
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Text message
///
///````
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
//public struct TextMessage: Codable {
//
//    // MARK: - Properties
//
//    var sender: Sender?
//    let recipient: Recipient
//    var timestamp: UInt32?
//
//    /// optional ID of Identity to use as a sender
//    ///
//    var persona_id: String?
//
//    /// Id of the application that is the owner of the thread. This property is not
//    /// sent or it is set to null if the recepient is the owner of the thread.
//    ///
//    var owner_app_id: String?
//
//    var persona: Dictionary<AnyObject, AnyObject>
//    let message: Message
//
//    // MARK: - Init
//
//    public init(recipient: Recipient, message: Message) {
//
//        self.recipient = recipient
//        self.message = message
//    }
//}
