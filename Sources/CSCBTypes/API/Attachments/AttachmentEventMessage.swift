//
//  AttachmentEvent
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Attachment Event Message
///
public struct AttachmentEventMessage: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case attachment
    }

    // MARK: - Properties

    let attachment: Recipient

    // MARK: - Init

    /// AttachmentEvent
    ///
    /// - Parameters:
    ///   - attachment: ???
    ///
    public init(attachment: Recipient) {

        self.attachment = attachment
    }
}
