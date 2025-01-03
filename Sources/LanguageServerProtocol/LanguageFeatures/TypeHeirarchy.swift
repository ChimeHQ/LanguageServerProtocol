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
		textDocument: TextDocumentIdentifier,
		position: Position,
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

	public init(
		name: String,
		kind: SymbolKind,
		tags: [SymbolTag]? = nil,
		detail: String? = nil,
		uri: DocumentUri,
		range: LSPRange,
		selectionRange: LSPRange,
		data: LSPAny? = nil
	) {
		self.name = name
		self.kind = kind
		self.tags = tags
		self.detail = detail
		self.uri = uri
		self.range = range
		self.selectionRange = selectionRange
		self.data = data
	}
}

public typealias PrepareTypeHeirarchyResponse = [TypeHierarchyItem]?

public struct TypeHierarchySubtypesParams: Codable, Hashable, Sendable {
	public let workDoneToken: ProgressToken?
	public let partialResultToken: ProgressToken?
	public let item: TypeHierarchyItem

	public init(workDoneToken: ProgressToken? = nil, partialResultToken: ProgressToken? = nil, item: TypeHierarchyItem) {
		self.workDoneToken = workDoneToken
		self.partialResultToken = partialResultToken
		self.item = item
	}
}

public typealias TypeHierarchySubtypesResponse = [TypeHierarchyItem]?
