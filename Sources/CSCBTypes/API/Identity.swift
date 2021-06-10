//
//  Identity
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Identity of communication Entity
///
public struct Identity: Codable {

    // MARK: - TypeAliases

    public typealias IdentityID = Tagged<Identity, String>

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case id
        case name
        case profileImg = "profile_pic"
    }

    // MARK: - Properties

    let id: IdentityID
    let name: String
    let profileImg: String

    // MARK: - Init

    /// Identity
    ///
    /// - Parameters:
    ///   - id: Identity identifier (default identity id matches with recipient/sender)
    ///   - name: User name
    ///   - profileImg: URL or Base64 encoded image
    ///
    public init(id: IdentityID,
                name: String,
                profileImg: String) {

        self.id = id
        self.name = name
        self.profileImg = profileImg
    }
}
