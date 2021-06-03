////
////  BackgroundEvent
////  CSCBTypes
////
////  Created by ha100 on 05/20/2021.
////  Copyright © 2021 Ceska sporitelna. All rights reserved.
////
//
//import Foundation
//import Tagged
//
///// Background event
/////
///// Note: It will not open the conversation and it lets the bot to decide, if the
///// conversation will be opened. For example the seen event is background by default
/////
/////````
/////{
/////  "sender":{
/////    "id":"<ID>"
/////  },
/////  "recipient":{
/////    "id":"<PAGE_ID>"
/////  },
/////  "timestamp":1458692752478,
/////  "bg": true,
/////  "postback":{
/////    "payload": "<USER_DEFINED_PAYLOAD>"
/////  },
/////  "setSharedContext": {
/////    "webUserAgent": "Mozilla/5.0"
/////  }
/////}
/////````
/////
///// Passing the postback to specific app
/////
///// It's possible to override the default behavior, when the event is always passed to a primary receiver application and specify the target app using an postback.appId directive.
/////
/////````
/////{
/////  "sender":{
/////    "id":"<ID>"
/////  },
/////  "recipient":{
/////    "id":"<PAGE_ID>"
/////  },
/////  "timestamp":1458692752478,
/////  "bg": true,
/////  "postback":{
/////    "appId": "<TARGET APPLICATION ID>",
/////    "payload": "<USER_DEFINED_PAYLOAD>"
/////  }
/////}
/////````
/////
//public struct BackgroundEvent: Codable {
//
//    // MARK: - TypeAliases
//
//    typealias Timestamp = Tagged<Stamp, Int>
//
//    // MARK: - Types
//
//    enum CodingKeys: String, CodingKey {
//
//        case recipient
//        case sender
//        case timestamp
//        case background = "bg"
//        case postback
//        case context = "setSharedContext"
//    }
//
//    // MARK: - Properties
//
//    let recipient: Recipient
//    let sender: Sender
//    let timestamp: Timestamp
//    let background: Bool
//    let postback: Postback
//    let context: SharedContext
//
//    // MARK: - Init
//
//    /// Background event
//    ///
//    /// - Parameters:
//    ///   - recipient: <#recipient description#>
//    ///   - sender: <#sender description#>
//    ///   - timestamp: <#timestamp description#>
//    ///   - postback: <#postback description#>
//    ///   - context: <#context description#>
//    ///
//    public init(recipient: Recipient,
//                sender: Sender,
//                timestamp: Timestamp,
//                postback: Postback,
//                context: SharedContext) {
//
//        self.recipient = recipient
//        self.sender = sender
//        self.timestamp = timestamp
//        self.background = true
//        self.postback = postback
//        self.context = context
//    }
//}
