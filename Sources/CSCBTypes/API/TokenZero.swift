//
//  TokenZero
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

public struct TokenZero: Codable {

    // MARK: - TypeAliases

    public typealias Timestamp = Tagged<TokenZero, Stamp>

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case userToken = "_wcUserToken"
        case userID = "_wcUid"
        case windowOpen = "_wcOpen"
        case timestamp = "_wcTimestamp"
    }

    // MARK: - Properties

    fileprivate static let decoder = JSONDecoder()

    let userToken: TokenJWT
    public let userID: String
    let windowOpen: Bool
    let timestamp: Timestamp

    public var jwt: String {
        return self.userToken.jwt
    }
}

extension TokenZero: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "\n[ TokenZero ]\nuserToken: \(self.userToken)\nuserID: \(self.userID)\ntimestamp: \(self.timestamp)\nwindowOpen: \(self.windowOpen)"
    }
}

extension TokenZero: CustomStringConvertible {

    public var description: String {
        return self.debugDescription
    }
}

public struct TokenZeroDecodeError: Error {
    let error: String
}

extension Data {

    public func decode<T: Codable>(to: T.Type) -> Result<T, Error> {

        do {

            let token = try TokenZero.decoder.decode(T.self, from: self)
            return Result.success(token)

        } catch {

            let resultError = TokenZeroDecodeError(error: error.localizedDescription)
            return Result.failure(resultError)
        }
    }
}
