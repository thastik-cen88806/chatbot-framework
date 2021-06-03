//
//  ThreadPassover
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Thread Passover
///
public struct ThreadPassover: Codable {

    // MARK: - TypeAliases

    public typealias AppID = Tagged<App, String>

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case newOwner = "new_owner_app_id"
        case metadata
    }

    // MARK: - Properties

    let newOwner: AppID

    let metadata: String?

    // MARK: - Init

    /// Thread Passover
    ///
    /// - Parameters:
    ///   - newOwner: An application the conversation has been passed to
    ///   - metadata: text data
    ///
    public init(newOwner: AppID,
                metadata: String?) {

        self.newOwner = newOwner
        self.metadata = metadata
    }
}
