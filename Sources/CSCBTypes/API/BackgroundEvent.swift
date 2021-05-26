//
//  BackgroundEvent
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Background event
///
/// Note: It will not open the conversation and it lets the bot to decide, if the
/// conversation will be opened. For example the seen event is background by default
///
///````
///{
///  "sender":{
///    "id":"<ID>"
///  },
///  "recipient":{
///    "id":"<PAGE_ID>"
///  },
///  "timestamp":1458692752478,
///  "bg": true,
///  "postback":{
///    "payload": "<USER_DEFINED_PAYLOAD>"
///  },
///  "setSharedContext": {
///    "webUserAgent": "Mozilla/5.0"
///  }
///}
///````
///
/// Passing the postback to specific app
///
/// It's possible to override the default behavior, when the event is always passed to a primary receiver application and specify the target app using an postback.appId directive.
///
///````
///{
///  "sender":{
///    "id":"<ID>"
///  },
///  "recipient":{
///    "id":"<PAGE_ID>"
///  },
///  "timestamp":1458692752478,
///  "bg": true,
///  "postback":{
///    "appId": "<TARGET APPLICATION ID>",
///    "payload": "<USER_DEFINED_PAYLOAD>"
///  }
///}
///````
///
public struct BackgroundEvent: Codable {

    // MARK: - Properties

    let recipient: Recipient
    let sender: Sender
    let timestamp: UInt32
    let bg: Bool
    let postback: Postback
    let setSharedContext: SharedContext

    // MARK: - Init

    public init(recipient: Recipient,
                sender: Sender,
                timestamp: UInt32,
                postback: Postback,
                context: SharedContext) {

        self.recipient = recipient
        self.sender = sender
        self.timestamp = timestamp
        self.bg = true
        self.postback = postback
        self.setSharedContext = context
    }
}

//enum SMS {
//
//    case text
//    case typing
//    case quickReply
//    case img
//    case file
//    case buttonTemplate
//    case carousel
//    case deliveryEvent
//    case readEvent
//}
