// swift-tools-version: 5.8

import PackageDescription

let package = Package(
	name: "LanguageServerProtocol",
	platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
	products: [
		.library(
			name: "LanguageServerProtocol",
			targets: ["LanguageServerProtocol"]),

		.library(
			name: "LSPClient",
			targets: ["LSPClient"]),

		.library(
			name: "LSPServer",
			targets: ["LSPServer"]),
	],
	dependencies: [
		.package(url: "https://github.com/ChimeHQ/JSONRPC", from: "0.9.0"),

	],
	targets: [
		.target(
			name: "LanguageServerProtocol",
			dependencies: ["JSONRPC"]),
		.target(
			name: "LSPClient",
			dependencies: ["LanguageServerProtocol"]),
		.target(
			name: "LSPServer",
			dependencies: ["LanguageServerProtocol"]),

		.testTarget(
			name: "LanguageServerProtocolTests",
			dependencies: ["LanguageServerProtocol", "LSPClient"]),
	]
)

let swiftSettings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency")
]

for target in package.targets {
	var settings = target.swiftSettings ?? []
	settings.append(contentsOf: swiftSettings)
	target.swiftSettings = settings
}
