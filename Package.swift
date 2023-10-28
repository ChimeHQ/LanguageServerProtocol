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
			name: "LanguageServerProtocol-Client",
			targets: ["LanguageServerProtocol-Client"]),

		.library(
			name: "LanguageServerProtocol-Server",
			targets: ["LanguageServerProtocol-Server"]),
	],
	dependencies: [
		.package(url: "https://github.com/ChimeHQ/JSONRPC", from: "0.9.0"),

	],
	targets: [
		.target(
			name: "LanguageServerProtocol",
			dependencies: ["JSONRPC"]),
		.target(
			name: "LanguageServerProtocol-Client",
			dependencies: ["LanguageServerProtocol"]),
		.target(
			name: "LanguageServerProtocol-Server",
			dependencies: ["LanguageServerProtocol"]),

		.testTarget(
			name: "LanguageServerProtocolTests",
			dependencies: ["LanguageServerProtocol", "LanguageServerProtocol-Client"]),
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
