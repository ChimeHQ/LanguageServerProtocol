import Foundation

public typealias MonikerClientCapabilities = DynamicRegistrationClientCapabilities

public struct MonkierParams: Codable, Hashable, Sendable {
	public let workDoneToken: ProgressToken?
    public let partialResultToken: ProgressToken?

	public let textDocument: TextDocumentIdentifier
	public let position: Position

    public init(workDoneToken: ProgressToken? = nil, partialResultToken: ProgressToken? = nil, textDocument: TextDocumentIdentifier, position: Position) {
		self.workDoneToken = workDoneToken
        self.partialResultToken = partialResultToken
        self.textDocument = textDocument
        self.position = position
    }
}

public enum UniquenessLevel: Codable, Sendable {
	case document
	case project
	case group
	case scheme
	case global
	// public static let document = "document"
	// public static let project = "project"
	// public static let group = "group"
	// public static let scheme = "scheme"
	// public static let global = "global"
}

public enum MonikerKind : Codable, Sendable{
	case _import
	case export
	case local
	// public static let _import = "import"
	// public static let export = "export"
	// public static let local = "local"
}

public struct Moniker : Codable, Sendable {
	public let scheme: String
	public let identifier: String
	public let unique: UniquenessLevel
	public let kind: MonikerKind?
}


public typealias MonikerResponse = [Moniker]?
