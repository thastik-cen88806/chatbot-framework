//
//  Claim+Extensions
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import JWTKit

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
