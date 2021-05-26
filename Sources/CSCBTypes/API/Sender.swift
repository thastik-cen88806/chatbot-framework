//
//  Sender
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Sender object
///
/// SeeAlso: - [Webchat API Reference](https://ceskasporitelna.github.io/messaging-router-docs/docs/api)
///
public struct Sender: Codable {

    // MARK: - Properties

    let id: String

    // MARK: - Init

    /// Sender object
    ///
    /// - Parameter id: Sender identifier (channel or user)
    ///
    public init(id: String) {

        self.id = id
    }
}
