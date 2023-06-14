// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "LanguageServerProtocol",
    platforms: [.macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)],
    products: [
        .library(
            name: "LanguageServerProtocol",
            targets: ["LanguageServerProtocol"]),
    ],
    dependencies: [
		.package(url: "https://github.com/ChimeHQ/JSONRPC", "0.7.0"..."0.7.1"),
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
