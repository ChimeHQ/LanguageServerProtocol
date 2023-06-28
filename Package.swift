// swift-tools-version:5.5

import PackageDescription

let settings: [SwiftSetting] = [
//	.unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"])
]

let package = Package(
    name: "LanguageServerProtocol",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(
            name: "LanguageServerProtocol",
            targets: ["LanguageServerProtocol"]),
    ],
    dependencies: [
		.package(url: "https://github.com/ChimeHQ/JSONRPC", revision: "306acbe0de2e87e4f6c1dc3901613aa9df293754"),
    ],
    targets: [
        .target(
            name: "LanguageServerProtocol",
            dependencies: ["JSONRPC"],
			swiftSettings: settings),
        .testTarget(
            name: "LanguageServerProtocolTests",
            dependencies: ["LanguageServerProtocol"],
			swiftSettings: settings),
    ]
)
