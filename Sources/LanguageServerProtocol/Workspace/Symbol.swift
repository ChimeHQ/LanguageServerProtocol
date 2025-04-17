import Foundation

public struct WorkspaceSymbolClientCapabilities: Codable, Hashable, Sendable {
	public struct Properties: Codable, Hashable, Sendable {
		public var properties: [String]
	}

	public var dynamicRegistration: Bool?
	public var symbolKind: ValueSet<SymbolKind>?
	public var tagSupport: ValueSet<SymbolTag>?
	public var resolveSupport: Properties?

	public init(
		dynamicRegistration: Bool?, symbolKind: [SymbolKind]?, tagSupport: [SymbolTag]?,
		resolveSupport: Properties?
	) {
		self.dynamicRegistration = dynamicRegistration
		self.symbolKind = symbolKind.map { ValueSet(valueSet: $0) }
		self.tagSupport = tagSupport.map { ValueSet(valueSet: $0) }
		self.resolveSupport = resolveSupport
	}

	public init(
		dynamicRegistration: Bool?, symbolKind: [SymbolKind]?, tagSupport: [SymbolTag]?,
		resolveSupport: [String]?
	) {
		self.init(
			dynamicRegistration: dynamicRegistration,
			symbolKind: symbolKind,
			tagSupport: tagSupport,
			resolveSupport: resolveSupport.map { Properties(properties: $0) })
	}
}

public struct WorkspaceSymbolOptions: Codable, Hashable, Sendable {
	public var workDoneProgress: Bool?
	public var resolveProvider: Bool?

	public init(workDoneProgress: Bool? = nil, resolveProvider: Bool? = nil) {
		self.workDoneProgress = workDoneProgress
		self.resolveProvider = resolveProvider
	}
}

public typealias WorkspaceSymbolRegistrationOptions = WorkspaceSymbolOptions

public struct WorkspaceSymbolParams: Codable, Hashable, Sendable {
	public var workDoneToken: ProgressToken?
	public var partialResultToken: ProgressToken?
	public var query: String

	public init(
		query: String, workDoneToken: ProgressToken? = nil, partialResultToken: ProgressToken? = nil
	) {
		self.workDoneToken = workDoneToken
		self.partialResultToken = partialResultToken
		self.query = query
	}
}

public struct WorkspaceSymbol: Codable, Hashable, Sendable {
	public var name: String
	public var kind: SymbolKind
	public var tags: [SymbolTag]?
	public var location: TwoTypeOption<Location, TextDocumentIdentifier>?
	public var containerName: String?

	public init(
		name: String, kind: SymbolKind, tags: [SymbolTag]? = nil,
		location: TwoTypeOption<Location, TextDocumentIdentifier>? = nil,
		containerName: String? = nil
	) {
		self.name = name
		self.kind = kind
		self.tags = tags
		self.location = location
		self.containerName = containerName
	}
}

public typealias WorkspaceSymbolResponse = TwoTypeOption<[SymbolInformation], [WorkspaceSymbol]>?
