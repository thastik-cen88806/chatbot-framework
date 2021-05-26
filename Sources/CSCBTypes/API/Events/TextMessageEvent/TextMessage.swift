//
//  TextMessage
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Text Message
///
///````
///  {
///    "text": "Here is a quick reply!",
///    "quick_replies":[
///      {
///        "content_type":"text",
///        "title":"Search",
///        "payload":"<POSTBACK_PAYLOAD>"
///      }
///    ]
///  }
///````
///
public struct TextMessage: Codable {

    // MARK: - Properties

    let text: String

    // MARK: - Init

    /// Text Message
    ///
    /// - Parameter text: Message text
    ///
    public init(text: String) {

        self.text = text
    }
}
