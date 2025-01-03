import Foundation

public typealias TypeHierarchyOptions = WorkDoneProgressOptions

public struct TypeHierarchyRegistrationOptions: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentIdentifier
	public let position: Position
	public let workDoneToken: ProgressToken?
}

public struct TypeHierarchyPrepareParams: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentIdentifier
	public let position: Position
	public let workDoneToken: ProgressToken?

	public init(
		textDocument: TextDocumentIdentifier, position: Position,
		workDoneToken: ProgressToken? = nil
	) {
		self.textDocument = textDocument
		self.position = position
		self.workDoneToken = workDoneToken
	}
}

public struct TypeHierarchyItem: Codable, Hashable, Sendable {
	public let name: String
	public let kind: SymbolKind
	public let tags: [SymbolTag]?
	public let detail: String?
	public let uri: DocumentUri
	public let range: LSPRange
	public let selectionRange: LSPRange
	public let data: LSPAny?
}

public typealias PrepareTypeHeirarchyResponse = [TypeHierarchyItem]?
