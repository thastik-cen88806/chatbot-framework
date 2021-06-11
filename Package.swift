// swift-tools-version:5.3

import PackageDescription

let deps: [Package.Dependency] = [
    .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-tagged.git", from: "0.5.0"),
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0-rc"),
    .package(url: "https://github.com/vapor/leaf", from: "4.0.0-rc"),
    .package(url: "https://github.com/krzysztofzablocki/Sourcery", .exact("1.3.1")),
    .package(url: "https://github.com/Realm/SwiftLint", from: "0.28.1"),
    .package(url: "https://github.com/shibapm/Komondor.git", from: "1.0.0")
]

let targets: [Target] = [
    .target(name: "ChatbotDemo", dependencies: ["CSCB"]),
    .target(name: "CSCB", dependencies: ["CSCBTypes"]),
    .target(name: "CSCBTypes",
            dependencies: [
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]),
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
    .testTarget(name: "ChatbotTests", dependencies: ["CSCBTypes"])
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
        .executable(name: "ChatbotDemo", targets: ["ChatbotDemo"]),
        .executable(name: "ChatbotMockServer", targets: ["ChatbotMockServer"]),
        .library(name: "CSCB", targets: ["CSCB"]),
        .library(name: "CSCBTypes", targets: ["CSCBTypes"]),
    ],
    dependencies: deps,
    targets: targets,
    swiftLanguageVersions: [.v5]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-push": "swift test",
            "pre-commit": [
                "swift run swiftlint autocorrect --path Sources/",
                "swift test",
//                "swift run swiftformat .",
                "git add .",
            ],
        ],
    ]).write()
#endif
