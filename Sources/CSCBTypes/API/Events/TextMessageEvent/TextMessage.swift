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
/// Example:
/// ========
///````javascript
///  {
///    "text": "Here is a quick reply!"
///  }
///````
///
public struct TextMessage: Encodable {

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

// MARK: - Debug

extension TextMessage: CustomDebugStringConvertible {

    public var debugDescription: String {

        return "\(self.text)"
    }
}

extension TextMessage: CustomStringConvertible {

    public var description: String {

        return self.debugDescription
    }
}

// MARK: - Decodable

extension TextMessage: Decodable {

    /// Quite controversial checking of `QuickReplyMessage.CodingKeys` during `TextMessage` decoding
    ///
    /// - Note: `QuickReplyMessage` and `TextMessage` objects are very similar because both contain `CodingKeys.text`
    ///             and the `CodingKeys.replies` is present only in `QuickReplyMessage`
    ///
    /// - Problem:  There is a potential problem during sequential `ChatMessage` object decoding when we receive
    ///             `QuickReplyMessage` and the decoder tries to decode `TextMessage` first, which succedes because
    ///             `TextMessage.CodingKeys.text` is present. Thus `TextMessage` struct is returned from the decoding
    ///             pipeline and never reaches `QuickReplyMessage` decoding stage. There are these checks rather than
    ///             ordering the decoding pipeline stages in specific order and hoping nobody will reorder them in the
    ///             future. have a cookie
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: `DecodingError.typeMismatch`
    ///
    public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: QuickReplyMessage.CodingKeys.self)

        guard values.allKeys.doesNotIncludeReplies else {

            let context = DecodingError.Context(codingPath: [QuickReplyMessage.CodingKeys.replies],
                                                debugDescription: "replies key is present this is a quickReply message type")

            throw DecodingError.typeMismatch(QuickReplyMessage.CodingKeys.self, context)
        }

        text = try values.decode(String.self, forKey: .text)
    }
}

extension Array where Element == QuickReplyMessage.CodingKeys {

    var doesNotIncludeReplies: Bool {
        return !self.contains(.replies)
    }
}
