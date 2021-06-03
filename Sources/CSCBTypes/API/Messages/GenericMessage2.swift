////
////  GenericMessage
////  CSCBTypes
////
////  Created by ha100 on 05/20/2021.
////  Copyright © 2021 Ceska sporitelna. All rights reserved.
////
//
//import Foundation
//
///// Generic Message
/////
/////````
/////  {
/////    "text": "Here is a quick reply!",
/////    "quick_replies":[
/////      {
/////        "content_type":"text",
/////        "title":"Search",
/////        "payload":"<POSTBACK_PAYLOAD>"
/////      }
/////    ]
/////  }
/////````
/////
//public struct GenericMessage: Codable {
//
//    // MARK: - Types
//
//    enum CodingKeys: String, CodingKey {
//
//        case text
//        case quickReplies = "quick_replies"
//    }
//
//    // MARK: - Properties
//
//    let text: String
//
//    let quickReplies: Array<QuickReply>
//
//    // MARK: - Init
//
//    /// Generic Message
//    ///
//    /// - Parameters:
//    ///   - text: ??
//    ///   - quickReplies: ??
//    ///
//    public init(text: String,
//                quickReplies: Array<QuickReply>) {
//
//        self.text = text
//        
//        self.quick_replies = quickReplies
//    }
//}
