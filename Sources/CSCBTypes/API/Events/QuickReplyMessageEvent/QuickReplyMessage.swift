//
//  QuickReplyMessage
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

public struct QuickReplyMessage: Codable, AutoEquatable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case text
        case replies = "quick_replies"
    }

    // MARK: - Properties

    let text: String
    let replies: Array<QuickReply>

    // MARK: - Init

    /// Text Message
    ///
    /// - Parameter text: Message text
    ///
    public init(text: String,
                replies: Array<QuickReply>) {

        self.text = text
        self.replies = replies
    }
}

// MARK: - Debug

extension QuickReplyMessage: CustomDebugStringConvertible {

    public var debugDescription: String {

        return "\(self.text) \(self.replies)"
    }
}

extension QuickReplyMessage: CustomStringConvertible {

    public var description: String {

        return self.debugDescription
    }
}
