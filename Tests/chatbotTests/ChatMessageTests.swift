///
///  ChatMessageTests
///  ChatbotTests
///
///  Created by ha100 on 05/20/2021.
///  Copyright © 2021 Ceska sporitelna. All rights reserved.
///

import Foundation
import XCTest
@testable import CSCBTypes

final class ChatMessageTests: XCTestCase {

    func test_ChatMessage_canBeDecoded_fromJSON() {

        do {

            let files = try self.bundle().paths(forResourcesOfType: "json", inDirectory: nil)
            let objects = try self.decodeResources()

            XCTAssertEqual(objects.count, files.count, "there should be exactly \(files.count) objects decoded from json directory")

        } catch {
            XCTFail("we should be able to access the test data for json parsing")
        }
    }

    func test_ChatMessage_canParse_QuickReplies() {

        do {

            let objects = try self.decodeResources()

            XCTAssertTrue(objects.contains(where: { obj in
                obj.Type == .quickReply
            }), "there should be exactly 2 elements parsed from json directory")

        } catch {
            XCTFail("we should be able to access the test data for json parsing")
        }
    }
}

extension ChatMessageTests {

    enum TestError: Error {
        
        case decode
        case bundle
        case url
    }

    /// this monstrosity is needed until `SPM` does copy `Resources` into built bundle so we can use `Bundle.main`
    ///
    func bundle() throws -> Bundle {

        guard let currentBundle = Bundle.allBundles.filter({ $0.bundlePath.hasSuffix(".xctest") }).first,
        let realBundle = Bundle(path: "\(currentBundle.bundlePath)/../../../../Tests/ChatbotTests/Resources") else {
            throw TestError.bundle
        }

        return realBundle
    }

    /// json parsing exported to avoid repetition
    ///
    /// - Throws: `TestError`
    /// - Returns: `Array` of successfully parsed `ChatMessage` objects
    ///
    func decodeResources() throws -> Array<ChatMessage> {

        do {

            return try self.bundle()
            .paths(forResourcesOfType: "json", inDirectory: nil)
            .compactMap { urlString -> ChatMessage in

                guard let url = URL(string: "file://" + urlString) else { throw TestError.url }

                let data = try Data(contentsOf: url)
                let obj = try JSONDecoder().decode(ChatMessage.self, from: data)

                return obj
            }

        } catch {
            throw TestError.decode
        }
    }
}
