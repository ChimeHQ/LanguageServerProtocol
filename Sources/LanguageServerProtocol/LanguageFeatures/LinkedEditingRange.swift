import Foundation

public typealias LinkedEditingRangeClientCapabilities = DynamicRegistrationClientCapabilities

public struct LinkedEditingRangeParams: Codable, Hashable, Sendable {
	public let workDoneToken: ProgressToken?
    public let partialResultToken: ProgressToken?

	public let textDocument: TextDocumentIdentifier
	public let position: Position

    public init(workDoneToken: ProgressToken? = nil, partialResultToken: ProgressToken? = nil, textDocument: TextDocumentIdentifier, position: Position) {
		self.workDoneToken = workDoneToken
        self.partialResultToken = partialResultToken
        self.textDocument = textDocument
        self.position = position
    }
}

public struct LinkedEditingRanges : Codable, Sendable {
	public let ranges: [LSPRange]
	public let wordPattern: String?

	public init(ranges: [LSPRange], wordPattern: String? = nil) {
		self.ranges = ranges
		self.wordPattern = wordPattern
	}
}


public typealias LinkedEditingRangeResponse = LinkedEditingRanges?
