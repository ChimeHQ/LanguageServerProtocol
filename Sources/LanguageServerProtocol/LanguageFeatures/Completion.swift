import Foundation
import JSONRPC

public struct CompletionClientCapabilities: Codable, Hashable, Sendable {
	public struct CompletionItem: Codable, Hashable, Sendable {
		public struct ResolveSupport: Codable, Hashable, Sendable {
			public var properties: [String]

			public init(properties: [String]) {
				self.properties = properties
			}
		}

		public let snippetSupport: Bool?
		public let commitCharactersSupport: Bool?
		public let documentationFormat: [MarkupKind]?
		public let deprecatedSupport: Bool?
		public let preselectSupport: Bool?
		public var tagSupport: ValueSet<CompletionItemTag>?
		public var insertReplaceSupport: Bool?
		public var resolveSupport: ResolveSupport?
		public var insertTextModeSupport: ValueSet<InsertTextMode>?
		public var labelDetailsSupport: Bool?

		public init(
			snippetSupport: Bool? = nil,
			commitCharactersSupport: Bool? = nil,
			documentationFormat: [MarkupKind]? = nil,
			deprecatedSupport: Bool? = nil,
			preselectSupport: Bool? = nil,
			tagSupport: ValueSet<CompletionItemTag>? = nil,
			insertReplaceSupport: Bool? = nil,
			resolveSupport: CompletionItem.ResolveSupport? = nil,
			insertTextModeSupport: ValueSet<InsertTextMode>? = nil,
			labelDetailsSupport: Bool? = nil
		) {
			self.snippetSupport = snippetSupport
			self.commitCharactersSupport = commitCharactersSupport
			self.documentationFormat = documentationFormat
			self.deprecatedSupport = deprecatedSupport
			self.preselectSupport = preselectSupport
			self.tagSupport = tagSupport
			self.insertReplaceSupport = insertReplaceSupport
			self.resolveSupport = resolveSupport
			self.insertTextModeSupport = insertTextModeSupport
			self.labelDetailsSupport = labelDetailsSupport
		}
	}

	public struct CompletionList: Codable, Hashable, Sendable {
		public var itemDefaults: [String]?

		public init(itemDefaults: [String]? = nil) {
			self.itemDefaults = itemDefaults
		}
	}

	public var dynamicRegistration: Bool?
	public var completionItem: CompletionItem?
	public var completionItemKind: ValueSet<CompletionItemKind>?
	public var contextSupport: Bool?
	public var insertTextMode: InsertTextMode?
	public var completionList: CompletionList?

	public init(
		dynamicRegistration: Bool? = nil,
		completionItem: CompletionItem? = nil,
		completionItemKind: ValueSet<CompletionItemKind>? = nil,
		contextSupport: Bool? = nil,
		insertTextMode: InsertTextMode? = nil,
		completionList: CompletionClientCapabilities.CompletionList? = nil
	) {
		self.dynamicRegistration = dynamicRegistration
		self.completionItem = completionItem
		self.completionItemKind = completionItemKind
		self.contextSupport = contextSupport
		self.insertTextMode = insertTextMode
		self.completionList = completionList
	}
}

public enum CompletionTriggerKind: Int, Codable, Hashable, Sendable {
	case invoked = 1
	case triggerCharacter = 2
	case triggerForIncompleteCompletions = 3
}

public enum CompletionItemKind: Int, CaseIterable, Codable, Hashable, Sendable {
	case text = 1
	case method = 2
	case function = 3
	case constructor = 4
	case field = 5
	case variable = 6
	case `class` = 7
	case interface = 8
	case module = 9
	case property = 10
	case unit = 11
	case value = 12
	case `enum` = 13
	case keyword = 14
	case snippet = 15
	case color = 16
	case file = 17
	case reference = 18
	case folder = 19
	case enumMember = 20
	case constant = 21
	case `struct` = 22
	case event = 23
	case `operator` = 24
	case typeParameter = 25
}

public enum CompletionItemTag: Int, CaseIterable, Codable, Hashable, Sendable {
	case deprecated = 1
}

public struct CompletionContext: Codable, Hashable, Sendable {
	public let triggerKind: CompletionTriggerKind
	public let triggerCharacter: String?

	public init(triggerKind: CompletionTriggerKind, triggerCharacter: String?) {
		self.triggerKind = triggerKind
		self.triggerCharacter = triggerCharacter
	}
}

public struct CompletionParams: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentIdentifier
	public let position: Position
	public let context: CompletionContext?

	public init(
		textDocument: TextDocumentIdentifier, position: Position, context: CompletionContext?
	) {
		self.textDocument = textDocument
		self.position = position
		self.context = context
	}

	public init(
		uri: DocumentUri, position: Position, triggerKind: CompletionTriggerKind,
		triggerCharacter: String?
	) {
		let td = TextDocumentIdentifier(uri: uri)
		let ctx = CompletionContext(triggerKind: triggerKind, triggerCharacter: triggerCharacter)

		self.init(textDocument: td, position: position, context: ctx)
	}
}

public enum InsertTextFormat: Int, Codable, Hashable, Sendable {
	case plaintext = 1
	case snippet = 2
}

public struct CompletionItem: Codable, Hashable, Sendable {
	public let label: String
	public let kind: CompletionItemKind?
	public let detail: String?
	public let documentation: TwoTypeOption<String, MarkupContent>?
	public let deprecated: Bool?
	public let preselect: Bool?
	public let sortText: String?
	public let filterText: String?
	public let insertText: String?
	public let insertTextFormat: InsertTextFormat?
	public let textEdit: TextEdit?
	public let additionalTextEdits: [TextEdit]?
	public let commitCharacters: [String]?
	public let command: Command?
	public let data: LSPAny?

	public init(
		label: String,
		kind: CompletionItemKind? = nil,
		detail: String? = nil,
		documentation: TwoTypeOption<String, MarkupContent>? = nil,
		deprecated: Bool? = nil,
		preselect: Bool? = nil,
		sortText: String? = nil,
		filterText: String? = nil,
		insertText: String? = nil,
		insertTextFormat: InsertTextFormat? = nil,
		textEdit: TextEdit? = nil,
		additionalTextEdits: [TextEdit]? = nil,
		commitCharacters: [String]? = nil,
		command: Command? = nil,
		data: LSPAny? = nil
	) {
		self.label = label
		self.kind = kind
		self.detail = detail
		self.documentation = documentation
		self.deprecated = deprecated
		self.preselect = preselect
		self.sortText = sortText
		self.filterText = filterText
		self.insertText = insertText
		self.insertTextFormat = insertTextFormat
		self.textEdit = textEdit
		self.additionalTextEdits = additionalTextEdits
		self.commitCharacters = commitCharacters
		self.command = command
		self.data = data
	}
}

public struct CompletionList: Codable, Hashable, Sendable {
	public let isIncomplete: Bool
	public let items: [CompletionItem]

	public init(isIncomplete: Bool, items: [CompletionItem]) {
		self.isIncomplete = isIncomplete
		self.items = items
	}
}

public typealias CompletionResponse = TwoTypeOption<[CompletionItem], CompletionList>?

extension TwoTypeOption where T == [CompletionItem], U == CompletionList {
	public var items: [CompletionItem] {
		switch self {
		case .optionA(let v):
			return v
		case .optionB(let list):
			return list.items
		}
	}

	public var isIncomplete: Bool {
		switch self {
		case .optionA:
			return false
		case .optionB(let value):
			return value.isIncomplete
		}
	}
}

public struct CompletionRegistrationOptions: Codable {
	public let documentSelector: DocumentSelector?
	public let triggerCharacters: [String]?
	public let resolveProvider: Bool?
}

public enum InsertTextMode: Int, CaseIterable, Codable, Hashable, Sendable {
	case asIs = 1
	case adjustIndentation = 2
}
