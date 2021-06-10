//
//  ChatbotDemo
//  ChatbotFramework
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import CSCBExternal
import CSCBTypes
import Tagged

let sema = DispatchSemaphore(value: 0)

let channelID: Tagged<Channel, String> = "e5932cce-0705-4261-9194-3bd482aba287"

guard let client = try? CBFrameworkExternal(url: "https://webchat.csast.csas.cz/") else {

    fatalError(">>> failed url")
}

sleep(3)

guard let senderID = client.token?.userID else {
    fatalError(">>> failed senderID")
}

let sender = Sender(id: senderID)
let recipient = Recipient(id: channelID)

let json = Init(init: [:],
                sender: sender,
                recipient: recipient)

try? client.send(json)

sleep(1)

extension String {

    static var msgRndID: String {
        return String(randomWithLength: 7, allowedCharactersType: .alphaNumeric)
    }
}

extension Date {

    static var currentTimeStamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

let start = Start(messageId: "\(senderID).\(channelID).\(String.msgRndID).\(String.msgRndID)",
                  postback: Postback(payload: "start", appId: nil),
                  recipient: recipient,
                  sender: sender,
                  context: SharedContext(auth: nil, lang: "cs", viewport: nil, webPage: nil, webUserAgent: UserAgent.agent),
                  timestamp: Tagged<Stamp, Int64>(rawValue: Date.currentTimeStamp))

print(start)

try? client.send(start)

_ = sema.wait(timeout: .now() + 10)

/// Credits: https://github.com/Flinesoft/HandySwift/tree/main/Sources/HandySwift
///
extension String {

    /// The type of allowed characters.
    public enum AllowedCharacters {
        /// Allow all numbers from 0 to 9.
        case numeric
        /// Allow all alphabetic characters ignoring case.
        case alphabetic
        /// Allow both numbers and alphabetic characters ignoring case.
        case alphaNumeric
        /// Allow all characters appearing within the specified String.
        case allCharactersIn(String)
    }

    /// Returns a random character from the String.
    ///
    /// - Returns: A random character from the String or `nil` if empty.
    public var sample: Character? {
        isEmpty ? nil : self[index(startIndex, offsetBy: Int(randomBelow: count)!)]
    }

    /// Returns a given number of random characters from the String.
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

    /// Create new instance with random numeric/alphabetic/alphanumeric String of given length.
    ///
    /// - Parameters:
    ///   - randommWithLength:      The length of the random String to create.
    ///   - allowedCharactersType:  The allowed characters type, see enum `AllowedCharacters`.
    ///
    public init(randomWithLength length: Int,
                allowedCharactersType: AllowedCharacters) {

        let allowedCharsString: String = {

            switch allowedCharactersType {

                case .numeric: return "0123456789"

                case .alphabetic: return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

                case .alphaNumeric: return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

                case let .allCharactersIn(allowedCharactersString): return allowedCharactersString
            }
        }()

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
