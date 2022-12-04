// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Coral",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v11),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "Coral", targets: ["Coral"]),
        .executable(name: "coralcli", targets: ["CoralCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0"..<"3.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/imink-app/InkMoya.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Coral",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "InkMoya", package: "InkMoya"),
            ],
            resources: [.copy("API/SampleData")]),
        
        .executableTarget(
            name: "CoralCLI",
            dependencies: [
                "Coral",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        
        .testTarget(
            name: "CoralTests",
            dependencies: ["Coral"]),
    ]
)
