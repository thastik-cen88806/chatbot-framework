//
//  JPayload
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import JWTKit

/// Example:
/// ========
///````javascript
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
    var userID: String?
    var channelID: String?
    var ignoreCookie: BoolClaim?
    var issuedAt: IssuedAtClaim
    var expiration: ExpirationClaim?

    // MARK: - Init

    public init(type: String,
                bid: String,
                userID: String?,
                channelID: String?,
                ignoreCookie: BoolClaim?,
                issuedAt: IssuedAtClaim,
                expiration: ExpirationClaim?) throws {

        self.type = type
        self.bid = bid
        self.userID = userID
        self.channelID = channelID
        self.ignoreCookie = ignoreCookie
        self.issuedAt = issuedAt
        self.expiration = expiration
    }

    // MARK: - Lifecycle

    /// token validity checks
    ///
    /// - Parameter signer: default signer
    /// - Throws: `CBError.tokenJWTExpired` to encapsulate `JWTError.claimVerificationFailure`
    ///           and prevent the need to import `JWTKit` outside of the scope
    ///
    public func verify(using signer: JWTSigner) throws {

        guard let expiry = self.expiration else {
            return
        }

        do {
            try expiry.verifyNotExpired()
        } catch {
            throw CBError.tokenJWTExpired
        }
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
