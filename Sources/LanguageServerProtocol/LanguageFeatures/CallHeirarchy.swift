import Foundation

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
	public let data: LSPAny?

	public init(name: String,
				kind: SymbolKind,
				tag: [SymbolTag]? = nil,
				detail: String? = nil,
				uri: DocumentUri,
				range: LSPRange,
				selectionRange: LSPRange,
				data: LSPAny? = nil) {
		self.name = name
		self.kind = kind
		self.tag = tag
		self.detail = detail
		self.uri = uri
		self.range = range
		self.selectionRange = selectionRange
		self.data = data
	}
}

public typealias CallHierarchyPrepareResponse = [CallHierarchyItem]?

public struct CallHierarchyIncomingCallsParams: Codable, Hashable {
	public let workDoneToken: ProgressToken?
	public let partialResultToken: ProgressToken?

	public let item: CallHierarchyItem

	public init(item: CallHierarchyItem, workDoneToken: ProgressToken? = nil, partialResultToken: ProgressToken? = nil) {
		self.workDoneToken = workDoneToken
		self.partialResultToken = partialResultToken
		self.item = item
	}
}

public struct CallHierarchyIncomingCall: Codable, Hashable {
	public let from: CallHierarchyItem
	public let fromRanges: [LSPRange]
}

public typealias CallHierarchyIncomingCallsResponse = [CallHierarchyIncomingCall]?

public typealias CallHierarchyOutgoingCallsParams = CallHierarchyIncomingCallsParams

public struct CallHierarchyOutgoingCall: Codable, Hashable {
	public let to: CallHierarchyItem
	public let fromRanges: [LSPRange]
}

public typealias CallHierarchyOutgoingCallsResponse = [CallHierarchyOutgoingCall]?
