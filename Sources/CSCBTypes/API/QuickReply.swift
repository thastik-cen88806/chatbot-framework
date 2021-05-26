//
//  QuickReply
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Quick Reply
///
///````
///{
///  "content_type":"text",
///  "title":"Search",
///  "payload":"<POSTBACK_PAYLOAD>"
///}
///````
///
/// SeeAlso: - [Webchat API Reference](https://ceskasporitelna.github.io/messaging-router-docs/docs/api)
///
public struct QuickReply: Codable {

    // MARK: - Properties

    let contentType: String
    let title: String
    let payload: String?

    // MARK: - Init

    /// Quick Reply
    ///
    /// - Parameters:
    ///   - contentType: ???????????????????????????????????????????????????????????????????????????????????????????
    ///   - title: The QRs label
    ///   - payload: Developers defined payload
    ///
    public init(contentType: String,
                title: String,
                payload: String) {

        self.contentType = contentType
        self.title = title
        self.payload = payload
    }
}
