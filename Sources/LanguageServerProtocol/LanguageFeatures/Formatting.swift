import Foundation

public typealias DocumentFormattingClientCapabilities = DynamicRegistrationClientCapabilities
public typealias DocumentRangeFormattingClientCapabilities = DynamicRegistrationClientCapabilities

public struct FormattingOptions: Codable, Hashable, Sendable {
	public let tabSize: Int
	public let insertSpaces: Bool

	public init(tabSize: Int, insertSpaces: Bool) {
		self.tabSize = tabSize
		self.insertSpaces = insertSpaces
	}
}

public struct DocumentFormattingParams: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentIdentifier
	public let options: FormattingOptions

	public init(textDocument: TextDocumentIdentifier, options: FormattingOptions) {
		self.textDocument = textDocument
		self.options = options
	}
}

public struct DocumentRangeFormattingParams: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentIdentifier
	public let range: LSPRange
	public let options: FormattingOptions

	public init(textDocument: TextDocumentIdentifier, range: LSPRange, options: FormattingOptions) {
		self.textDocument = textDocument
		self.range = range
		self.options = options
	}
}

public struct DocumentOnTypeFormattingParams: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentIdentifier
	public let position: Position
	public let ch: String
	public let options: FormattingOptions

	public init(
		textDocument: TextDocumentIdentifier, position: Position, ch: String,
		options: FormattingOptions
	) {
		self.textDocument = textDocument
		self.position = position
		self.ch = ch
		self.options = options
	}
}

public typealias FormattingResult = [TextEdit]?
