//
//  ChannelPayload
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Channel Payload Object
///
public struct ChannelPayload: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case payload
    }

    // MARK: - Properties

    let payload: String

    // MARK: - Init

    /// Channel Payload Object
    ///
    /// - Parameter payload: Developer defined payload
    ///
    public init(payload: String) {

        self.payload = payload
    }
}
