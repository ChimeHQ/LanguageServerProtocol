import Foundation

public struct HoverClientCapabilities: Codable, Hashable, Sendable {
	public var dynamicRegistration: Bool?
	public var contentFormat: [MarkupKind]?

	public init(dynamicRegistration: Bool?, contentFormat: [MarkupKind]?) {
		self.dynamicRegistration = dynamicRegistration
		self.contentFormat = contentFormat
	}
}

public struct Hover: Codable, Hashable, Sendable {
	public let contents: ThreeTypeOption<MarkedString, [MarkedString], MarkupContent>
	public let range: LSPRange?

	public init(
		contents: ThreeTypeOption<MarkedString, [MarkedString], MarkupContent>, range: LSPRange?
	) {
		self.contents = contents
		self.range = range
	}

	public init(contents: String, range: LSPRange? = nil) {
		self.contents = .optionA(.optionA(contents))
		self.range = range
	}
}

public typealias HoverResponse = Hover?
