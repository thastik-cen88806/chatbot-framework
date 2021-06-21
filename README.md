# chatbot-framework

• framework consists of  `CSCB` library target that you can import in your project, and  `ChatbotDemo` executable target for sample client script for demonstration and integration testing purposes. Additional concepts can be observed in included playgrounds that "should" work after you build the required imports for iOS platform. This is required since the playground is for iOS platform.

• API communication objects are exported via `CSCBTypes` target which gets shared between  `CSCB` and `Playground` to ensure compatibility and code reuse

## CI/CD Tools

• xcode used to build: Version 12.5 (12E262)

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

## CSCB

• uses Apple `URLSession` framework  for networking

## ChatbotDemo

• sample script to fire request to a mock server, providing example implemmentation

## ChatbotTests

• some unit tests for now

# Resources

`CSIN\INET_DEVELOPERS` role under `Windows` system in `REDIM` is needed to be able to access internal Sporka repositories, additional requests should be delegated to `devtools@csas.cz`

[Sporka webchat-ui](https://sdf.csin.cz/stash/projects/WCH/repos/webchat-ui/browse)

[Sporka webchat](https://sdf.csin.cz/stash/projects/WCH/repos/webchat/browse)

[Messaging Router chatbot platform](https://ceskasporitelna.github.io/messaging-router-docs/)

[Facebook Messenger Platform](https://developers.facebook.com/docs/messenger-platform)

[Swagger Editor](https://editor.swagger.io/)


