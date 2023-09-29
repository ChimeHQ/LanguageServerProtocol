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

        .library(
            name: "LanguageServerProtocol-Client",
            targets: ["LanguageServerProtocol-Client"]),

        .library(
            name: "LanguageServerProtocol-Server",
            targets: ["LanguageServerProtocol-Server"]),
    ],
    dependencies: [
		// .package(url: "https://github.com/ChimeHQ/JSONRPC", from: "0.8.0"),
		.package(name: "JSONRPC", path: "../JSONRPC"),
		// NOTE: Since stdio pipe is commonly used as transport, it is very important to never print
		// non-transport related messages to stdout, we therefore require proper logging
		.package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
    ],
    targets: [
        .target(
            name: "LanguageServerProtocol",
            dependencies: [
				.product(name: "Logging", package: "swift-log"),
				"JSONRPC"
			],
			swiftSettings: settings),
        .target(
            name: "LanguageServerProtocol-Client",
            dependencies: ["LanguageServerProtocol"],
			swiftSettings: settings),
        .target(
            name: "LanguageServerProtocol-Server",
            dependencies: ["LanguageServerProtocol"],
			swiftSettings: settings),

        .testTarget(
            name: "LanguageServerProtocolTests",
            dependencies: ["LanguageServerProtocol"],
			swiftSettings: settings),
    ]
)
