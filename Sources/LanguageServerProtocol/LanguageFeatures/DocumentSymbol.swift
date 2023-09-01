import Foundation

public struct DocumentSymbolClientCapabilities: Codable, Hashable, Sendable {
    public var dynamicRegistration: Bool?
    public var symbolKind: ValueSet<SymbolKind>?
    public var hierarchicalDocumentSymbolSupport: Bool?
    public var tagSupport: ValueSet<SymbolTag>?
    public var labelSupport: Bool?

    public init(dynamicRegistration: Bool, symbolKind: ValueSet<SymbolKind>? = nil, hierarchicalDocumentSymbolSupport: Bool? = nil, tagSupport: ValueSet<SymbolTag>? = nil, labelSupport: Bool? = nil) {
        self.dynamicRegistration = dynamicRegistration
        self.symbolKind = symbolKind
        self.hierarchicalDocumentSymbolSupport = hierarchicalDocumentSymbolSupport
        self.tagSupport = tagSupport
        self.labelSupport = labelSupport
    }
}

public struct DocumentSymbolParams: Codable, Hashable, Sendable {
    public let textDocument: TextDocumentIdentifier

    public init(textDocument: TextDocumentIdentifier) {
        self.textDocument = textDocument
    }
}

public struct DocumentSymbol: Codable, Hashable, Sendable {
	public init(name: String, detail: String? = nil, kind: SymbolKind, deprecated: Bool? = nil, range: LSPRange, selectionRange: LSPRange, children: [DocumentSymbol]? = nil) {
		self.name = name
		self.detail = detail
		self.kind = kind
		self.deprecated = deprecated
		self.range = range
		self.selectionRange = selectionRange
		self.children = children
	}

    public let name: String
    public let detail: String?
    public let kind: SymbolKind
    public let deprecated: Bool?
    public let range: LSPRange
    public let selectionRange: LSPRange
    public let children: [DocumentSymbol]?
}


public typealias DocumentSymbolResponse = TwoTypeOption<[DocumentSymbol], [SymbolInformation]>?
