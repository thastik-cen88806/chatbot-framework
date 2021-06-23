//
//  TokenZero+Extensions
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

fileprivate let tokenDecoder = JSONDecoder()

extension Data {

    /// Helper to allow oneline decode action
    ///
    /// Example:
    /// ========
    ///````swift
    ///let jsonWhiteSpace = "\\s"
    ///let jsonPattern = "\\{(.*)\\}"
    ///
    ///let x = try? string
    ///    .replacingOccurrences(of: jsonWhiteSpace, with: "", options: .regularExpression)
    ///    .match(regex: jsonPattern)
    ///    .data(using: .utf8)?
    ///    .decode(to: TokenZero.self)
    ///````
    /// - Parameter to: object to which the underlining data will be decoded (currently `TokenZero`)
    /// - Throws: `CBError.tokenZeroDecode` if decoding json value fails
    /// - Returns: object specified as parameter (currently `TokenZero`)
    ///
    func decode<T: Codable>(to: T.Type) throws -> T {

        do {

            return try tokenDecoder.decode(T.self, from: self)

        } catch {

            throw CBError.tokenZeroDecode(error: error.localizedDescription)
        }
    }
}

extension String {

    public func decodeTokenZero() throws -> TokenZero {

        let jsonWhiteSpace = "\\s"
        let jsonPattern = "\\{(.*)\\}"

        guard let result = try? self
            .replacingOccurrences(of: jsonWhiteSpace, with: "", options: .regularExpression)
            .match(regex: jsonPattern)
            .data(using: .utf8)?
            .decode(to: TokenZero.self) else {

                throw CBError.tokenZeroHTMLExtract(error: self)
        }

        return result
    }
}
