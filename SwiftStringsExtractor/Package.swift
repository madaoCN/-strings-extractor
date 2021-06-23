// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftStringsExtractor",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(name: "StringsExtractor", targets: ["StringsExtractor"]),
        .library(name: "SwiftStringsExtractor",
            targets: ["SwiftStringsExtractor"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name:"SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", .exact("0.50300.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.1")),
        .package(url: "https://github.com/mxcl/Path.swift.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "StringsExtractor",
            dependencies: [
                "SwiftStringsExtractor",
                "SwiftSyntax",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Path", package: "Path.swift")
            ]
        ),
        .target(
            name: "SwiftStringsExtractor",
            dependencies: ["SwiftSyntax"],
            resources: [.process("lib_InternalSwiftSyntaxParser.dylib")]),
        .testTarget(
            name: "SwiftStringsExtractorTests",
            dependencies: ["SwiftStringsExtractor"]),
    ]
)
