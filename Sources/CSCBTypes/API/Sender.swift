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
public struct Sender<T: TaggedType>: Codable where T: Equatable, T: Codable, T.Tag: Identified {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case id
    }

    // MARK: - Properties

    let id: T

    // MARK: - Init

    /// Sender object
    ///
    /// - Parameter id: Sender identifier (channel Tagged<Channel, String> or user Tagged<Persona, String>)
    ///
    public init(id: T) {

        self.id = id
    }
}

// MARK: - Equatability

extension Sender: Equatable {}

public func == <T>(lhs: Sender<T>, rhs: Sender<T>) -> Bool {

    guard lhs.id == rhs.id else { return false }

    return true
}
