///
///  String+Random
///  CSCBTypes
///
///  Created by ha100 on 05/20/2021.
///  Copyright © 2021 Ceska sporitelna. All rights reserved.
///

import Foundation

extension String {

    /// randomly generated alphaNumeric `String` of size 7
    ///
    public static var msgID: String {
        String(randomWithLength: 7, allowedCharacters: .alphaNumeric)
    }

    /// base64 from a randomly generated alphabetic `String` of size 16
    ///
    public static var socketKey: String {
        Data((0..<16).map { _ in UInt8.random(in: 97...122) }).base64EncodedString()
    }

    /// The type of allowed characters in random generated `String`
    ///
    private enum AllowedCharacters: String {

        case alphabetic = "abcdefghijklmnopqrstuvwxyz"

        case alphaNumeric = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    }

    /// create random `String` instance of given length from set of specified `AllowedCharacters`
    ///
    /// - Note: the force unwrap is safe in this case since it returns nil only
    ///         in case when the `Array` of characters is empty. this scenario will
    ///         not occur since we get the elements from `AllowedCharacters`
    ///
    /// - Parameters:
    ///   - randommWithLength: The length of the random String to create.
    ///   - allowedCharacters: The allowed characters type, see enum `AllowedCharacters`.
    ///
    private init(randomWithLength length: Int,
                allowedCharacters: AllowedCharacters) {

        self.init((0..<length).map { _ in allowedCharacters.rawValue.randomElement()! })
    }
}
