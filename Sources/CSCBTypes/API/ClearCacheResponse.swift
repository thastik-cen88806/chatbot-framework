//
//  ClearCacheResponse
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Clear Cache Response
///
public struct ClearCacheResponse: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case number = "num"
    }

    // MARK: - Properties

    let number: UInt32?

    // MARK: - Init

    /// Clear Cache Response
    ///
    /// - Parameter number: Number of deleted records
    ///
    public init(number: UInt32?) {

        self.number = number
    }
}
