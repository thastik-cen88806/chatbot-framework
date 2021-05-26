//
//  Recipient
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Recipient object
///
/// SeeAlso: - [Webchat API Reference](https://ceskasporitelna.github.io/messaging-router-docs/docs/api)
///
public struct Recipient: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case id
    }

    // MARK: - Properties

    let id: String

    // MARK: - Init

    /// Recipient object
    ///
    /// - Parameter id: Recipient identifier (channel or user)
    ///
    public init(id: String) {

        self.id = id
    }
}
