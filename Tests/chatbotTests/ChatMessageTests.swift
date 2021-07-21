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

            let files = try self.loadResources()
            let objects = try self.decodeResources()

            XCTAssertEqual(objects.count, files.count, "there should be exactly \(files.count) objects decoded from json directory")

        } catch {
            XCTFail(">>> we should be able to access the test data for json parsing: \(error)")
        }
    }

    func test_ChatMessage_canParse_QuickReplies() {

        do {

            let objects = try self.decodeResources()

            XCTAssertTrue(objects.contains { $0.caseName == .quickReply },
                          "there should be `.quickReply` object parsed from json directory")

        } catch {

            XCTFail(">>> we should be able to access the test data for json parsing: \(error)")
        }
    }
}

extension ChatMessageTests {

    enum TestError: Error {

        case decode
        case bundle(String)
        case url
    }

    /// this monstrosity is needed until `SPM` does copy `Resources` into built bundle so we can use `Bundle.main`
    ///
    func bundle() throws -> Bundle {

        #if Xcode
        return Bundle(for: type(of: self ))
        #else

        let path = "/../../../../Tests/ChatbotTests/Resources"

        guard let currentBundle = Bundle.allBundles
                .filter({ $0.bundlePath.hasSuffix(".xctest") })
                .first,
              let realBundle = Bundle(path: "\(currentBundle.bundlePath)\(path)") else {

            throw TestError.bundle("\(Bundle.allBundles.filter({ $0.bundlePath.hasSuffix(".xctest") }).first?.bundlePath ?? "N/A")\(path)")
        }

        return realBundle

        #endif
    }

    /// return string paths to resources
    ///
    /// - Note: the preprocessor macro needed due to different test results from `Xcode` and command line `swift test`
    ///
    /// - Returns: `Array` of paths to resources
    ///
    func loadResources() throws -> Array<String> {

        #if Xcode

        return try self.bundle()
            .resourceURL
            .flatMap { try FileManager.default.contentsOfDirectory(at: $0, includingPropertiesForKeys: nil).first }
            .flatMap { URL(string: "\($0.absoluteString)Contents/Resources/") }
            .flatMap { try FileManager.default.contentsOfDirectory(at: $0, includingPropertiesForKeys: nil) }
            .flatMap { $0.compactMap { $0.absoluteString } } ?? []

        #else

        return try self.bundle()
            .paths(forResourcesOfType: "json", inDirectory: nil)

        #endif
    }

    /// parse `ChatMessage` object from `URL`
    ///
    /// - Note: the preprocessor macro needed due to different test results from `Xcode` and command line `swift test`
    ///
    /// - Throws: `TestError.url`
    /// - Returns: `ChatMessage` object
    ///
    func decodeResources() throws -> Array<ChatMessage> {

        try self.loadResources()
            .compactMap { urlString in

                #if Xcode

                guard let url = URL(string: urlString) else {

                    throw TestError.url
                }
                #else

                guard let url = URL(string: "file://" + urlString) else {

                    throw TestError.url
                }
                #endif

                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(ChatMessage.self, from: data)
            }
    }
}
