//
//  JWTToken
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import JWTKit

public struct TokenJWT {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case payload = "payload"
    }

    // MARK: - Properties

    private static let secret = "9WXvaghg3uXfYsbPw42p"
    private let signers = JWTSigners()

    public let payload: JPayload
    public let jwt: String

    // MARK: - Init

    /// Creates object from jwt `String` with token expiration check
    ///
    /// - Parameter jwt: `String`
    /// - Throws: `CBError.tokenJWTExpired`
    ///
    public init(jwt: String) throws {

        self.jwt = jwt
        
        signers.use(.hs256(key: TokenJWT.secret))
        payload = try signers.verify(jwt, as: JPayload.self)
    }
}

// MARK: - Debug

extension TokenJWT: CustomDebugStringConvertible {

    public var debugDescription: String {

        return "\(self.payload)"
    }
}

extension TokenJWT: CustomStringConvertible {

    public var description: String {

        return self.debugDescription
    }
}

// MARK: - Codable

extension TokenJWT: Decodable {

    public init(from decoder: Decoder) throws {

        let single = try decoder.singleValueContainer()
        try self.init(jwt: single.decode(String.self))
    }
}

extension TokenJWT: Encodable {

    public func encode(to encoder: Encoder) throws {

        var single = encoder.singleValueContainer()
        try single.encode(payload)
    }
}
