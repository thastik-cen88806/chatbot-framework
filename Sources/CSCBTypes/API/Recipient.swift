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
public struct Recipient<T: TaggedType>: Codable where T: Codable, T.Tag: Identified {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case id
    }

    // MARK: - Properties

    let id: T

    // MARK: - Init

    /// Recipient object
    ///
    /// - Parameter id: Recipient identifier (channel Tagged<Channel, String> or user Tagged<Persona, String>)
    ///
    public init(id: T) {

        self.id = id
    }
}
