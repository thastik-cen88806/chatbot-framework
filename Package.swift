// swift-tools-version:5.3

import PackageDescription

let deps: [Package.Dependency] = [
    .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.0")
]

let targets: [Target] = [
    .target(
        name: "ChatbotDemo",
        dependencies: []),
    .target(
        name: "ChatbotFrameworkExternal",
        dependencies: ["Starscream"]),
    .target(
        name: "ChatbotFramework",
        dependencies: []),
    .testTarget(
        name: "ChatbotTests",
        dependencies: ["ChatbotFramework"])
]

let package = Package(
    name: "ChatbotFramework",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .executable( name: "ChatbotDemo", targets: ["ChatbotFrameworkExternal"]),
        .library(
            name: "ChatbotFrameworkExternal",
            targets: ["ChatbotFrameworkExternal"]),
        .library(
            name: "ChatbotFramework",
            targets: [])
    ],
    dependencies: deps,
    targets: targets,
    swiftLanguageVersions: [.v5]
)
