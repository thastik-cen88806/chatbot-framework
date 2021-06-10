    import XCTest
    @testable import CSCBTypes

    final class chatbotTests: XCTestCase {

        let sut = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0IjoidSIsImJpZCI6IjRuZENTWkFYY2REIiwidWlkIjoiM1dqckJGMzF5RGxFIiwiY2lkIjoiZTU5MzJjY2UtMDcwNS00MjYxLTkxOTQtM2JkNDgyYWJhMjg3IiwiaWdub3JlQnJvd3NlckNvb2tpZSI6ZmFsc2UsImlhdCI6MTYyMjYzMDAzMywiZXhwIjoxNjIyNjMzNjMzfQ.TH11j16zDKZiItP_TwA2AjJlCyAuNXo69qRbIkfSZ1k"

        let json = """
        {
          "t": "u",
          "bid": "4ndCSZAXcdD",
          "uid": "3WjrBF31yDlE",
          "cid": "e5932cce-0705-4261-9194-3bd482aba287",
          "ignoreBrowserCookie": false,
          "iat": 1622630033,
          "exp": 1622633633
        }
        """

        let decoder = JSONDecoder()

//        func test_JWTParsing_intoObject_detectsExpiredToken() {
//
//            do {
//
//                let jwt = try TokenJWT(jwt: sut)
//
//                guard let jsonData = json.data(using: .utf8) else {
//
//                    XCTFail("it is essential to be able to create Data from utf8 String")
//                    return
//                }
//
//                let token = try decoder.decode(JPayload.self, from: jsonData)
//
//                XCTFail("should not parse token if expired")
//            } catch {
//
//                XCTAssertEqual(error as! CBError, CBError.tokenJWTExpired, "error thrown from the framework should be `CBError.tokenJWTExpired`")
//            }
//        }
    }
