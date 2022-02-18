import Foundation
import AnyCodable

public struct CompletionClientCapabilities: Codable, Hashable {
    public struct CompletionItem: Codable, Hashable {
        public let snippetSupport: Bool?
        public let commitCharactersSupport: Bool?
        public let documentationFormat: [MarkupKind]?
        public let deprecatedSupport: Bool?
        public let preselectSupport: Bool?
        public var tagSupport: ValueSet<CompletionItemTag>?
        public var insertReplaceSupport: Bool?

        public var insertTextModeSupport: ValueSet<InsertTextMode>?
        public var labelDetailsSupport: Bool?

        public init(snippetSupport: Bool, commitCharactersSupport: Bool, documentationFormat: [MarkupKind], deprecatedSupport: Bool, preselectSupport: Bool) {
            self.snippetSupport = snippetSupport
            self.commitCharactersSupport = commitCharactersSupport
            self.documentationFormat = documentationFormat
            self.deprecatedSupport = deprecatedSupport
            self.preselectSupport = preselectSupport
        }
    }

    public var dynamicRegistration: Bool?
    public var completionItem: Bool?
    public var completionItemKind: Bool?
    public var contextSupport: Bool?
    public var insertTextMode: Bool?
    public var completionList: Bool?
}

public enum CompletionTriggerKind: Int, Codable, Hashable {
    case invoked = 1
    case triggerCharacter = 2
    case triggerForIncompleteCompletions = 3
}

public enum CompletionItemKind: Int, CaseIterable, Codable, Hashable {
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

public enum CompletionItemTag: Int, CaseIterable, Codable, Hashable {
    case deprecated = 1
}

public struct CompletionContext: Codable, Hashable {
    public let triggerKind: CompletionTriggerKind
    public let triggerCharacter: String?

    public init(triggerKind: CompletionTriggerKind, triggerCharacter: String?) {
        self.triggerKind = triggerKind
        self.triggerCharacter = triggerCharacter
    }
}

public struct CompletionParams: Codable, Hashable {
    public let textDocument: TextDocumentIdentifier
    public let position: Position
    public let context: CompletionContext?

    public init(textDocument: TextDocumentIdentifier, position: Position, context: CompletionContext?) {
        self.textDocument = textDocument
        self.position = position
        self.context = context
    }

    public init(uri: DocumentUri, position: Position, triggerKind: CompletionTriggerKind, triggerCharacter: String?) {
        let td = TextDocumentIdentifier(uri: uri)
        let ctx = CompletionContext(triggerKind: triggerKind, triggerCharacter: triggerCharacter)

        self.init(textDocument: td, position: position, context: ctx)
    }
}

public enum InsertTextFormat: Int, Codable, Hashable {
    case plaintext = 1
    case snippet = 2
}

public struct CompletionItem: Codable, Equatable {
    public let label: String
    public let kind: CompletionItemKind?
    public let detail: String?
    public let documentation: AnyCodable?
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
    public let data: AnyCodable?
}

public struct CompletionList: Codable, Equatable {
    public let isIncomplete: Bool
    public let items: [CompletionItem]

    public init(isIncomplete: Bool, items: [CompletionItem]) {
        self.isIncomplete = isIncomplete
        self.items = items
    }
}

public typealias CompletionResponse = TwoTypeOption<[CompletionItem], CompletionList>?

public extension TwoTypeOption where T == [CompletionItem], U == CompletionList {
    var items: [CompletionItem] {
        switch self {
        case .optionA(let v):
            return v
        case .optionB(let list):
            return list.items
        }
    }

    var isIncomplete: Bool {
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

public enum InsertTextMode: Int, CaseIterable, Codable, Hashable {
    case asIs = 1
    case adjustIndentation = 2
}
