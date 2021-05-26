//
//  Persona
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Persona
///
public struct Persona: Codable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case name
        case profileImg = "profile_picture"
    }

    // MARK: - Properties

    let name: String
    let profileImg: String

    // MARK: - Init

    /// Persona
    ///
    /// - Parameters:
    ///   - name: users full name
    ///   - profileImg: picture url
    ///
    public init(name: String,
                profileImg: String) {

        self.name = name
        self.profileImg = profileImg
    }
}
