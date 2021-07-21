//
//  TokenZero
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// initial token received from backend carrying the `JWTToken` required to init
/// the websocket communication
///
public struct TokenZero: Codable {

    // MARK: - TypeAliases

    public typealias Timestamp = Tagged<TokenZero, Stamp>
    public typealias UserID = Tagged<Persona, String>

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case userToken = "_wcUserToken"
        case userID = "_wcUid"
        case windowOpen = "_wcOpen"
        case timestamp = "_wcTimestamp"
    }

    // MARK: - Properties

    let userToken: TokenJWT
    public let userID: UserID
    let windowOpen: Bool
    let timestamp: Timestamp

    public var jwt: String {
        return self.userToken.jwt
    }
}

// MARK: - Debug

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
