// swift-tools-version:5.3

import PackageDescription

let deps: [Package.Dependency] = [
    .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-tagged.git", from: "0.5.0"),
    .package(url: "https://github.com/Realm/SwiftLint", from: "0.28.1"),
    .package(url: "https://github.com/shibapm/Komondor.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
]

let targets: [Target] = [
    .target(name: "ChatbotDemo", dependencies: ["CSCB"]),
    .target(name: "CSCB", dependencies: ["CSCBTypes",
                                         .product(name: "Logging", package: "swift-log")]),
    .target(name: "CSCBTypes",
            dependencies: [
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]),
    .testTarget(name: "ChatbotTests",
                dependencies: ["CSCBTypes"],
                resources: [.process("Resources")])
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
            ],
        ],
    ]).write()
#endif
