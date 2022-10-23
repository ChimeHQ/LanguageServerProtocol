import Foundation

import AnyCodable

public typealias CallHierarchyClientCapabilities = DynamicRegistrationClientCapabilities

public typealias CallHierarchyOptions = WorkDoneProgressOptions

public typealias CallHierarchyRegistrationOptions = StaticRegistrationWorkDoneProgressTextDocumentRegistrationOptions

public struct CallHierarchyPrepareParams: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentIdentifier
	public let position: Position
	public let workDoneToken: ProgressToken?

	public init(textDocument: TextDocumentIdentifier, position: Position, workDoneToken: ProgressToken? = nil) {
		self.textDocument = textDocument
		self.position = position
		self.workDoneToken = workDoneToken
	}
}

public struct CallHierarchyItem: Codable, Hashable {
	public let name: String
	public let kind: SymbolKind
	public let tag: [SymbolTag]?
	public let detail: String?
	public let uri: DocumentUri
	public let range: LSPRange
	public let selectionRange: LSPRange
	public let data: AnyCodable?
}

public typealias CallHierarchyPrepareResponse = [CallHierarchyItem]?
