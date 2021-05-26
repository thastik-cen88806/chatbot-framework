//
//  JWTToken
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import JWTKit

public struct JWTToken {

    // MARK: - Properties

    private static let secret = "9WXvaghg3uXfYsbPw42p"
    private let signers = JWTSigners()

    public let payload: JPayload
    public var jwt = ""

    // MARK: - Init

    public init() {

        payload = JPayload(t: "u",
                          bid: "6fy0SXklVeP",
                          uid: "3Wgs8d111OV0",
                          cid: "e5932cce-0705-4261-9194-3bd482aba287",
                          ignoreCookie: true,
                          issuedAt: .init(value: Date()),
                          expiration: .init(value: .distantFuture))

        do {

            self.jwt = try self.auth()
        } catch {
            print(">>> jwt sign: \(error)")
        }
    }

    // MARK: - Lifecycle

    private func auth() throws -> String {

        signers.use(.hs256(key: JWTToken.secret))

        return try self.signers.sign(payload)
    }

    /// Parses the JWT and verifies its signature
    ///
    public func verify() throws -> JPayload {

        return try signers.verify(jwt, as: JPayload.self)
    }
}

struct OriginalPayload: JWTPayload, Equatable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case subject = "sub"
        case expiration = "exp"
        case isAdmin = "admin"
    }

    // MARK: - Properties

    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var isAdmin: Bool

    // MARK: - Lifecycle

    func verify(using signer: JWTSigner) throws {

        try self.expiration.verifyNotExpired()
    }
}

//{
//  "t": "u",
//  "bid": "6fy0SXklVeP",
//  "uid": "3Wgs8d111OV0",
//  "cid": "e5932cce-0705-4261-9194-3bd482aba287",
//  "ignoreBrowserCookie": false,
//  "iat": 1621844518,
//  "exp": 1621848118
//}
public struct JPayload: JWTPayload, Equatable {

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case t
        case bid
        case uid
        case cid
        case ignoreCookie = "ignoreBrowserCookie"
        case issuedAt = "iat"
        case expiration = "exp"
    }

    // MARK: - Properties

    var t: String
    var bid: String
    var uid: String
    var cid: String
    var ignoreCookie: BoolClaim
    var issuedAt: IssuedAtClaim
    var expiration: ExpirationClaim

    // MARK: - Lifecycle

    public func verify(using signer: JWTSigner) throws {

        try self.expiration.verifyNotExpired()
    }
}

//struct Payload: JWTPayload, Equatable {
//
//    // MARK: - Types
//
//    enum CodingKeys: String, CodingKey {
//
//        case appId
//        case channelId = "cid"
//        case contentHash = "sha1"
//        case tokenType = "t"
//    }
//
//    // MARK: - Properties
//
//    let tokenType = "a"
//    var expiration: ExpirationClaim
//    var isAdmin: Bool
//
//    // MARK: - Init
//
//    // MARK: - Lifecycle
//
//    func verify(using signer: JWTSigner) throws {
//
//        try self.expiration.verifyNotExpired()
//    }
//}
