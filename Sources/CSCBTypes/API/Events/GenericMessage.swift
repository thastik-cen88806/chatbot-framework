//
//  GenericMessage
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Template Message
///
public struct GenericMessage<A: Codable>: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case attachment
    }

    // MARK: - Properties

    let attachment: A

    // MARK: - Init

    /// Message Attachment
    ///
    /// - Parameters:
    ///   - attachment: ???
    ///
    public init(attachment: A) {

        self.attachment = attachment
    }
}
