import Foundation

public typealias DocumentHighlightClientCapabilities = DynamicRegistrationClientCapabilities

public typealias DocumentHighlightOptions = WorkDoneProgressOptions

public struct DocumentHighlightRegistrationOptions: Codable, Hashable, Sendable {
	public var documentSelector: DocumentSelector?
	public var workDoneProgress: Bool?

	public init(
		documentSelector: DocumentSelector? = nil, workDoneProgress: Bool? = nil
	) {
		self.documentSelector = documentSelector
		self.workDoneProgress = workDoneProgress
	}
}

public struct DocumentHighlightParams: Codable, Hashable, Sendable {
	public var textDocument: TextDocumentIdentifier
	public var position: Position
	public var workDoneToken: ProgressToken?
	public var partialResultToken: ProgressToken?

	public init(
		textDocument: TextDocumentIdentifier, position: Position,
		workDoneToken: ProgressToken? = nil, partialResultToken: ProgressToken? = nil
	) {
		self.textDocument = textDocument
		self.position = position
		self.workDoneToken = workDoneToken
		self.partialResultToken = partialResultToken
	}
}

public enum DocumentHighlightKind: Int, CaseIterable, Codable, Hashable, Sendable {
	case Text = 1
	case Read = 2
	case Write = 3
}

public struct DocumentHighlight: Codable, Hashable, Sendable {
	public var range: LSPRange
	public var kind: DocumentHighlightKind?

	public init(
		range: LSPRange, kind: DocumentHighlightKind? = nil
	) {
		self.range = range
		self.kind = kind
	}
}

public typealias DocumentHighlightResponse = [DocumentHighlight]?
