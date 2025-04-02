// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cestrum-cli",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/Wadye17/CestrumCore", branch: "main"),
        .package(url: "https://github.com/jordanbaird/Prism.git", .upToNextMajor(from: "0.1.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "cestrum",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "CestrumCore", package: "CestrumCore"),
                .product(name: "Prism", package: "Prism")
            ]
        ),
    ]
)
