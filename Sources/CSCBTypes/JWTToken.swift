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

    public init(jwt: String) throws {

        self.jwt = jwt
        
        signers.use(.hs256(key: TokenJWT.secret))
        payload = try signers.verify(jwt, as: JPayload.self)
    }
}

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

///````
///{
///  "t": "u",
///  "bid": "4ndCSZAXcdD",
///  "uid": "3WjrBF31yDlE",
///  "cid": "e5932cce-0705-4261-9194-3bd482aba287",
///  "ignoreBrowserCookie": false,
///  "iat": 1622630033,
///  "exp": 1622633633
///}
///````
///
public struct JPayload: JWTPayload, Equatable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case type = "t"
        case bid
        case userID = "uid"
        case channelID = "cid"
        case ignoreCookie = "ignoreBrowserCookie"
        case issuedAt = "iat"
        case expiration = "exp"
    }

    // MARK: - Properties

    var type: String
    var bid: String
    var userID: String
    var channelID: String
    var ignoreCookie: BoolClaim
    var issuedAt: IssuedAtClaim
    var expiration: ExpirationClaim

    // MARK: - Lifecycle

    public func verify(using signer: JWTSigner) throws {

        try self.expiration.verifyNotExpired()
    }
}

extension JPayload: CustomDebugStringConvertible {

    public var debugDescription: String {

        return "type: \(self.type) "
        + "bid: \(self.bid) "
        + "userID: \(self.userID) "
        + "channelID: \(self.channelID) "
        + "ignoreCookie: \(self.ignoreCookie)\n"
        + "           issuedAt: \(self.issuedAt) "
        + "expiration: \(self.expiration) "
    }
}

extension JPayload: CustomStringConvertible {

    public var description: String {
        return self.debugDescription
    }
}

extension ExpirationClaim: CustomDebugStringConvertible {

    public var debugDescription: String {

        return "\(self.value)"
    }
}

extension ExpirationClaim: CustomStringConvertible {

    public var description: String {
        return self.debugDescription
    }
}

extension IssuedAtClaim: CustomDebugStringConvertible {

    public var debugDescription: String {

        return "\(self.value)"
    }
}

extension IssuedAtClaim: CustomStringConvertible {

    public var description: String {
        return self.debugDescription
    }
}

extension BoolClaim: CustomDebugStringConvertible {

    public var debugDescription: String {

        return "\(self.value)"
    }
}

extension BoolClaim: CustomStringConvertible {

    public var description: String {
        return self.debugDescription
    }
}
