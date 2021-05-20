// swift-tools-version:5.3

import PackageDescription

let deps: [Package.Dependency] = [
    .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0-rc"),
    .package(url: "https://github.com/vapor/leaf", from: "4.0.0-rc")
]

let targets: [Target] = [
    .target(name: "CSCBTypes", dependencies: []),
    .target(name: "CSCBExternal", dependencies: ["Starscream", "CSCBTypes"]),
    .target(name: "CSCB", dependencies: ["CSCBTypes"]),
    .target(name: "ChatbotMockServer",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Leaf", package: "leaf")
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
    ),
    .testTarget(name: "ChatbotTests", dependencies: ["CSCB"])
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
        .executable( name: "ChatbotDemo", targets: ["CSCBExternal"]),
        .executable(name: "ChatbotMockServer", targets: ["ChatbotMockServer"]),
        .library(name: "ChatbotFrameworkExternal", targets: ["CSCBExternal"]),
        .library(name: "ChatbotFramework", targets: ["CSCB"]),
        .library(name: "CSCBTypes", targets: ["CSCBTypes"]),
    ],
    dependencies: deps,
    targets: targets,
    swiftLanguageVersions: [.v5]
)
