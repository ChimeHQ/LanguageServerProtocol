// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LanguageServerProtocol",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LanguageServerProtocol",
            targets: ["LanguageServerProtocol"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ChimeHQ/JSONRPC", from: "0.3.0"),
    ],
    targets: [
        .target(
            name: "LanguageServerProtocol",
            dependencies: ["JSONRPC"]),
        .testTarget(
            name: "LanguageServerProtocolTests",
            dependencies: ["LanguageServerProtocol"]),
    ]
)
