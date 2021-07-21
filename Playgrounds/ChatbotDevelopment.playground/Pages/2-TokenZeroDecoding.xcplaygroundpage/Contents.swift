import Foundation
import PlaygroundSupport
import CSCBTypes
/*:
# 2 - TokenZero Decoding from raw HTML data

 `<TokenZero>` is acquired from `<https://webchat.csast.csas.cz/api/>` endpoint with query `<frame?cid=<Channel ID>>`
 there is one required header parameter `<Referer>` with value `<https://www.csast.csas.cz>`. Returned `<JWTToken>` is
 needed to regex extract from html.

 */
enum TokenZeroError: Error {
    case url
    case decode
}

do {

    try Bundle.main
    .paths(forResourcesOfType: "html", inDirectory: nil)
    .forEach { urlString in

        print("\n----- \(urlString.split(separator: "/").last ?? "N/A") -----")

        guard let url = URL(string: "file://" + urlString) else {

            throw TokenZeroError.url
        }

        let data = try Data(contentsOf: url)
        let string = String(data: data, encoding: .utf8)

        let jsonWhiteSpace = "\\s"
        let jsonPattern = "\\{(.*)\\}"

        guard let token = try string?
            .replacingOccurrences(of: jsonWhiteSpace, with: "", options: .regularExpression)
            .match(regex: jsonPattern)
            .data(using: .utf8)?
            .decode(to: TokenZero.self) else {

            throw TokenZeroError.decode
        }

        print(token)
    }
} catch {
    print(error)
}

//: [Previous](@previous)                                                      [Next](@next)
