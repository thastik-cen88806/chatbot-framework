# chatbot-framework

[Messaging Router chatbot platform](https://ceskasporitelna.github.io/messaging-router-docs/)
[Facebook Messenger Platform](https://developers.facebook.com/docs/messenger-platform)
[Swagger Editor](https://editor.swagger.io/)

• framework consists of two <`CSCBExternal`, `CSCB`> library targets that are importable in your project, and two <`ChatbotDemo`, `ChatbotMockServer`> executable targets for sample client script and mock server that serve for demonstration and integration testing purposes 

• API communication objects are exported via `CSCBTypes` target which gets shared between `CSCBExternal`, `CSCB` and `ChatbotMockServer` to ensure compatibility and code reuse

## CI/CD Tools

• swiftformat - is used to ensure uniform code formatting across multiple developers

• swiftlint - is used to check general code quality and standards

• sourcery - is used to autogenerate `Equatable` protocol conformances for `Enum`s with associated values

• komondor - is used to automate the use of the previous tools during commits and pull requests to remove the developer from the process

    it is needed to install the tool with `swift run komondor install` after initial `swift build` or after `swift package update`

## CSCBTypes

• types shared by server & framework targets

**additional checks for better safety and easier developer workflow**

• some fields in API objects are size restricted so we check and fail with appropriate error if input is invalid

• some `String` and `Int` values have been wrapped in Tagged type to avoid cross contamination - this brings some challenges during the `Codable` protocol conformance and JSON value handling and so custom Encoding and Decoding of types containing these values has to be implemmented

[Brandon Kase - Strings Are Evil](https://www.youtube.com/watch?v=UTm5p96KlEc)

[Tagged](https://www.pointfree.co/episodes/ep12-tagged)
[swift-tagged](https://github.com/pointfreeco/swift-tagged)

## CSCBExternal

• uses `Starscream` framework for networking - https://github.com/daltoniam/Starscream

• use of this taget is prefered over `CSCB` due to better stability until the native implementation is thoroughly tested and pronounced stable - multiple bug radars has been filed to Apple by comunity 

• it should be noted tho that the size of the framework is roughly 500kb bigger than the native `CSCB` target implementation and could be swapped for native implemmentation in constrained environments

## CSCB

• uses Apple `URLSession` framework  for networking

## ChatbotDemo

• simple script to fire request to a mock server, providing example implemmentation

## ChatbotMockServer

• uses `Vapor` framework

## ChatbotTests

• wishful thinking 4 now
