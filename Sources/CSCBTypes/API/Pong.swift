//
//  Pong
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

/// Pong reply to Ping
///
/// Example:
/// ========
///````javascript
/// {
///     "ping": 1623445169440,
///     "pong": 1623445169542
/// }
///````
///
public struct Pong: Codable, AutoEquatable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case ping
        case pong
    }

    // MARK: - Properties

    let ping: Int64
    let pong: Int64

    // MARK: - Init

    public init(ping: Int64,
                pong: Int64) {

        self.ping = ping
        self.pong = pong
    }
}

// MARK: - Debug

extension Pong: CustomDebugStringConvertible {

    public var debugDescription: String {

        return "\(self.ping) ← \(self.pong)"
    }
}

extension Pong: CustomStringConvertible {

    public var description: String {

        return self.debugDescription
    }
}
