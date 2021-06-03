//
//  TaggedType
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Phantom protocol marking `Tagged` type in `Sender` init
///
public protocol TaggedType {

    associatedtype Tag
    associatedtype RawValue
}

extension Tagged: TaggedType {}

/// Phantom protocol marking `Persona` and `Channel` types to limit the scope
/// of `Tagged` conformance in `Sender` init
///
public protocol Identified {}
