import Foundation

public typealias CallHierarchyClientCapabilities = DynamicRegistrationClientCapabilities

public typealias CallHierarchyOptions = WorkDoneProgressOptions

public typealias CallHierarchyRegistrationOptions =
	StaticRegistrationWorkDoneProgressTextDocumentRegistrationOptions

public struct CallHierarchyPrepareParams: Codable, Hashable, Sendable {
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

public struct CallHierarchyItem: Codable, Hashable, Sendable {
	private enum CodingKeys: String, CodingKey {
		case name, kind, detail, uri, range, selectionRange, data
		case tag = "tags"
	}

	private enum LegacyCodingKeys: String, CodingKey {
		case tag
	}

	public let name: String
	public let kind: SymbolKind
	public let tag: [SymbolTag]?
	public let detail: String?
	public let uri: DocumentUri
	public let range: LSPRange
	public let selectionRange: LSPRange
	public let data: LSPAny?

	public init(
		name: String,
		kind: SymbolKind,
		tag: [SymbolTag]? = nil,
		detail: String? = nil,
		uri: DocumentUri,
		range: LSPRange,
		selectionRange: LSPRange,
		data: LSPAny? = nil
	) {
		self.name = name
		self.kind = kind
		self.tag = tag
		self.detail = detail
		self.uri = uri
		self.range = range
		self.selectionRange = selectionRange
		self.data = data
	}

	public init(from decoder: Decoder) throws {
		let item = try decoder.container(keyedBy: CodingKeys.self)
		if item.contains(.tag) {
			tag = try item.decodeIfPresent([SymbolTag].self, forKey: .tag)
		} else {
			// Older versions encoded this property under its Swift name.
			let legacy = try decoder.container(keyedBy: LegacyCodingKeys.self)
			tag = try legacy.decodeIfPresent([SymbolTag].self, forKey: .tag)
		}
		name = try item.decode(String.self, forKey: .name)
		kind = try item.decode(SymbolKind.self, forKey: .kind)
		detail = try item.decodeIfPresent(String.self, forKey: .detail)
		uri = try item.decode(DocumentUri.self, forKey: .uri)
		range = try item.decode(LSPRange.self, forKey: .range)
		selectionRange = try item.decode(LSPRange.self, forKey: .selectionRange)
		data = try item.decodeIfPresent(LSPAny.self, forKey: .data)
	}
}

public typealias CallHierarchyPrepareResponse = [CallHierarchyItem]?

public struct CallHierarchyIncomingCallsParams: Codable, Hashable, Sendable {
	public let workDoneToken: ProgressToken?
	public let partialResultToken: ProgressToken?

	public let item: CallHierarchyItem

	public init(
		item: CallHierarchyItem, workDoneToken: ProgressToken? = nil,
		partialResultToken: ProgressToken? = nil
	) {
		self.workDoneToken = workDoneToken
		self.partialResultToken = partialResultToken
		self.item = item
	}
}

public struct CallHierarchyIncomingCall: Codable, Hashable, Sendable {
	public let from: CallHierarchyItem
	public let fromRanges: [LSPRange]

	public init(
		from: CallHierarchyItem, fromRanges: [LSPRange]
	) {
		self.from = from
		self.fromRanges = fromRanges
	}
}

public typealias CallHierarchyIncomingCallsResponse = [CallHierarchyIncomingCall]?

public typealias CallHierarchyOutgoingCallsParams = CallHierarchyIncomingCallsParams

public struct CallHierarchyOutgoingCall: Codable, Hashable, Sendable {
	public let to: CallHierarchyItem
	public let fromRanges: [LSPRange]

	public init(to: CallHierarchyItem, fromRanges: [LSPRange]) {
		self.to = to
		self.fromRanges = fromRanges
	}
}

public typealias CallHierarchyOutgoingCallsResponse = [CallHierarchyOutgoingCall]?
