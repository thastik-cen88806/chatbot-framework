///
///  ChatbotTests
///  ChatbotTests
///
///  Created by ha100 on 05/20/2021.
///  Copyright © 2021 Ceska sporitelna. All rights reserved.
///

    import XCTest
    @testable import CSCBTypes

    final class ChatbotTests: XCTestCase {

        let sut = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0IjoidSIsImJpZCI6IjRuZENTWkFYY2REIiwidWlkIjoiM1dqckJGMzF5RGxFIiwiY2lkIjoiZTU5MzJjY2UtMDcwNS00MjYxLTkxOTQtM2JkNDgyYWJhMjg3IiwiaWdub3JlQnJvd3NlckNvb2tpZSI6ZmFsc2UsImlhdCI6MTYyMjYzMDAzMywiZXhwIjoxNjIyNjMzNjMzfQ.TH11j16zDKZiItP_TwA2AjJlCyAuNXo69qRbIkfSZ1k"

        var json: String {"""
        {
          "t": "u",
          "bid": "4ndCSZAXcdD",
          "uid": "3WjrBF31yDlE",
          "cid": "e5932cce-0705-4261-9194-3bd482aba287",
          "ignoreBrowserCookie": false,
          "iat": \(Date.currentTimeStamp),
          "exp": \(Date.currentTimeStamp + 3000)
        }
        """}

        func test_JWTParsing_intoObject_detectsExpiredToken() {

            do {

                _ = try TokenJWT(jwt: sut)

                XCTFail("should not parse token if expired")
            } catch {

                XCTAssertEqual(error as! CBError, CBError.tokenJWTExpired, "error thrown from the framework should be `CBError.tokenJWTExpired`")
            }
        }

        func test_JWTParsing_creates_tokenObject() {

            let decoder = JSONDecoder()

            do {

                guard let jsonData = json.data(using: .utf8) else {

                    XCTFail("it is essential to be able to create Data from utf8 String")
                    return
                }

                let token = try decoder.decode(JPayload.self, from: jsonData)

                XCTAssertEqual(token.type, "u", "the parsed type should be same as in textual representation of the token")
                XCTAssertEqual(token.bid, "4ndCSZAXcdD", "the parsed type should be same as in textual representation of the token")
                XCTAssertEqual(token.userID, "3WjrBF31yDlE", "the parsed type should be same as in textual representation of the token")
                XCTAssertEqual(token.channelID, "e5932cce-0705-4261-9194-3bd482aba287", "the parsed type should be same as in textual representation of the token")
                XCTAssertEqual(token.ignoreCookie, false, "the parsed type should be same as in textual representation of the token")

            } catch {

                XCTFail("should parse valid json payload into structure")
            }
        }
    }
