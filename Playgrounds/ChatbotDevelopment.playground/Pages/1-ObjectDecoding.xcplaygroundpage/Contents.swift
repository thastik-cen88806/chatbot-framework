import Foundation
import PlaygroundSupport
import CSCBTypes
/*:
# 1 - Object decoding from JSON data

 To test decoding of new object add a new json payload to `<Resources>` directory of this playground page as a new file, then add a swift model object into `<Sources>` directory of `<CSCBTypes>` module and if the structure gets printed to the console from the playground, everything works fine

 */
struct URLError: Error {}

do {

    try Bundle.main
    .paths(forResourcesOfType: "json", inDirectory: nil)
    .forEach { urlString in

        print("\n----- \(urlString.split(separator: "/").last ?? "N/A") -----")

        guard let url = URL(string: "file://" + urlString) else { throw URLError() }

        let data = try Data(contentsOf: url)
        let obj = try JSONDecoder().decode(ChatMessage.self, from: data)

        print(obj)
    }
} catch {
    print(error)
}

/*:
 - Important:
There is a potential problem during sequential `<ChatMessage>` object decoding when we receive
`<QuickReplyMessage>` and the decoder tries to decode `<TextMessage>` first, which succedes because
`<TextMessage.CodingKeys.text>` is present. Thus `<TextMessage>` struct is returned from the decoding
pipeline and never reaches `<QuickReplyMessage>` decoding stage. There are these checks rather than
ordering the decoding pipeline stages in specific order and hoping nobody will reorder them in the
future.
 */

//: [Previous](@previous)                                                      [Next](@next)
