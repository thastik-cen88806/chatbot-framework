///
///  Stamp
///  CSCBTypes
///
///  Created by ha100 on 05/20/2021.
///  Copyright © 2021 Ceska sporitelna. All rights reserved.
///

import Foundation

public struct Stamp {

    // MARK: - Properties

    let value: Date

    // MARK: - Init

    public init(value: Date) {
        self.value = value
    }
}

// MARK: - Debug

extension Stamp: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "\(self.value)"
    }
}

extension Stamp: CustomStringConvertible {

    public var description: String {
        return self.debugDescription
    }
}

// MARK: - Codable

extension Stamp: Decodable {

    public init(from decoder: Decoder) throws {

        let container = try decoder.singleValueContainer()
        try self.init(value: .init(timeIntervalSince1970: container.decode(Double.self)))
    }
}

extension Stamp: Encodable {

    public func encode(to encoder: Encoder) throws {

        var container = encoder.singleValueContainer()
        try container.encode(value.timeIntervalSince1970)
    }
}
