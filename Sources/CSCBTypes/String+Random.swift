///
///  String+Random
///  CSCBTypes
///
///  Created by ha100 on 05/20/2021.
///  Copyright © 2021 Ceska sporitelna. All rights reserved.
///

import Foundation

/// Credits: https://github.com/Flinesoft/HandySwift/tree/main/Sources/HandySwift
///
extension String {

    /// Returns a random character from the String.
    ///
    /// - Returns: A random character from the String or `nil` if empty.
    ///
    public var sample: Character? {

        isEmpty ? nil : self[index(startIndex, offsetBy: Int(randomBelow: count)!)]
    }

    /// Returns a given number of random characters from the String
    ///
    /// - Parameters:
    ///   - size: The number of random characters wanted.
    /// - Returns: A String with the given number of random characters or `nil` if empty.
    ///
    @inlinable
    public func sample(size: Int) -> String? {

        guard !isEmpty else { return nil }

        var sampleElements = String()
        size.times { sampleElements.append(sample!) }

        return sampleElements
    }

    /// Create new instance with random alphanumeric String of given length
    ///
    /// - Parameters:
    ///   - randommWithLength:      The length of the random String to create.
    ///
    public init(randomWithLength length: Int) {

        let allowedCharsString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        self.init(allowedCharsString.sample(size: length)!)
    }
}

extension Int {

    /// Initializes a new `Int ` instance with a random value below a given `Int`.
    ///
    /// - Parameters:
    ///   - randomBelow: The upper bound value to create a random value with.
    ///
    public init?(randomBelow upperLimit: Int) {

        guard upperLimit > 0 else { return nil }

        self = .random(in: 0 ..< upperLimit)
    }

    /// Runs the code passed as a closure the specified number of times.
    ///
    /// - Parameters:
    ///   - closure: The code to be run multiple times.
    ///
    @inlinable
    public func times(_ closure: () throws -> Void) rethrows {

        guard self > 0 else { return }

        for _ in 0 ..< self { try closure() }
    }
}
