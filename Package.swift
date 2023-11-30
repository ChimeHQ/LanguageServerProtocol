// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "LanguageServerProtocol",
	platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
	products: [
		.library(name: "LanguageServerProtocol", targets: ["LanguageServerProtocol"]),
	],
	dependencies: [
		.package(url: "https://github.com/ChimeHQ/JSONRPC", from: "0.9.0"),

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

let swiftSettings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency")
]

for target in package.targets {
	var settings = target.swiftSettings ?? []
	settings.append(contentsOf: swiftSettings)
	target.swiftSettings = settings
}
