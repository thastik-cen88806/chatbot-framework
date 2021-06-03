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

        func testExample() {

            let jwt = try? TokenJWT(jwt: sut)

            let token = try? decoder.decode(JPayload.self, from: json.data(using: .utf8)!)


            XCTAssertEqual(jwt!.payload, token!, "the payload of the object should be parsed")
        }
    }
