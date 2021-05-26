//
//  ThreadTakeover
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Thread Takeover
///
public struct ThreadTakeover: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case previousOwner = "previous_owner_app_id"
        case metadata
    }

    // MARK: - Properties

    let previousOwner: String

    let metadata: String?

    // MARK: - Init

    /// Thread Takeover
    ///
    /// - Parameters:
    ///   - previousOwner: An application the conversation has been passed to
    ///   - metadata: text data
    ///
    public init(previousOwner: String,
                metadata: String?) {

        self.previousOwner = previousOwner
        self.metadata = metadata
    }
}
