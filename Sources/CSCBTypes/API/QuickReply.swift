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
/// Example:
/// ========
///````javascript
///{
///  "content_type":"text",
///  "title":"Search",
///  "payload":"<POSTBACK_PAYLOAD>"
///}
///````
///
public struct QuickReply: Codable, AutoEquatable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case contentType = "content_type"
        case title
        case payload
    }

    // MARK: - Properties

    let contentType: String
    let title: String

    let payload: String?

    // MARK: - Init

    /// Quick Reply
    ///
    /// - Parameters:
    ///   - contentType: ??
    ///   - title: The QRs label
    ///   - payload: Developers defined payload
    ///
    public init(contentType: String,
                title: String,
                payload: String?) {

        self.contentType = contentType
        self.title = title

        self.payload = payload
    }
}

// MARK: - Debug

extension QuickReply: CustomDebugStringConvertible {

    public var debugDescription: String {

        return "\(self.title)"
    }
}

extension QuickReply: CustomStringConvertible {

    public var description: String {

        return self.debugDescription
    }
}
