//
//  AttachmentPayload
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Attachment Payload
///
/// UsedIn: - Attachment
///
public struct AttachmentPayload: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case url
    }

    // MARK: - Properties

    let url: URL

    // MARK: - Init

    /// Payload Object
    ///
    /// - Parameter url: Attachment url
    ///
    public init(url: URL) {

        self.url = url
    }
}
