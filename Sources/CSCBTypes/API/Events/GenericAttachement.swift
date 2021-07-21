//
//  GenericAttachement
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Generic Attachement
///
/// Note: - abstract type used in `AttachmentEvent` and `TemplateEvent`
///
public struct GenericAttachement<T: Codable, P: Codable>: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case type
        case payload
    }

    // MARK: - Properties

    let type: T
    let payload: P

    // MARK: - Init

    /// Generic Attachement
    ///
    /// - Parameters:
    ///   - type: Attachment type
    ///   - payload: Attachment url
    ///
    public init(type: T,
                payload: P) {

        self.type = type
        self.payload = payload
    }
}
