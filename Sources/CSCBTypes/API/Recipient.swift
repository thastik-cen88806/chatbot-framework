//
//  Recipient
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Recipient object
///
public struct Recipient<T: TaggedType>: Codable where T: Equatable, T: Codable, T.Tag: Identified {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case id
    }

    // MARK: - Properties

    let id: T

    // MARK: - Init

    /// Recipient object
    ///
    /// - Parameter id: Recipient identifier (channel Tagged<Channel, String> or user Tagged<Persona, String>)
    ///
    public init(id: T) {

        self.id = id
    }
}

// MARK: - Equatability

extension Recipient: Equatable {}

public func == <T>(lhs: Recipient<T>, rhs: Recipient<T>) -> Bool {

    guard lhs.id == rhs.id else { return false }

    return true
}

//extension Recipient: ExpressibleByStringLiteral where T: Tagged, T.Tag == Channel, T.RawValue == String {
//
//    public init(stringLiteral value: String) {
//
//        self.init(id: Tagged<Channel, String>(rawValue: value) as! T)
//    }
//}
//
//extension Recipient: ExpressibleByExtendedGraphemeClusterLiteral where T.RawValue: ExpressibleByExtendedGraphemeClusterLiteral {
//    public typealias ExtendedGraphemeClusterLiteralType = T.RawValue.ExtendedGraphemeClusterLiteralType
//
//  public init(extendedGraphemeClusterLiteral: ExtendedGraphemeClusterLiteralType) {
//    self.init(id: T.RawValue(extendedGraphemeClusterLiteral: extendedGraphemeClusterLiteral))
//  }
//}
//
//extension Recipient: ExpressibleByStringLiteral where T.RawValue: ExpressibleByStringLiteral {
//    public typealias StringLiteralType = T.RawValue.StringLiteralType
//
//  public init(stringLiteral: StringLiteralType) {
//    self.init(id: T.RawValue(stringLiteral: stringLiteral))
//  }
//}
//
//extension Recipient: ExpressibleByUnicodeScalarLiteral where T.RawValue: ExpressibleByUnicodeScalarLiteral {
//    public typealias UnicodeScalarLiteralType = T.RawValue.UnicodeScalarLiteralType
//
//  public init(unicodeScalarLiteral: UnicodeScalarLiteralType) {
//    self.init(id: T.RawValue(unicodeScalarLiteral: unicodeScalarLiteral))
//  }
//}
