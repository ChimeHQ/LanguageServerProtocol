import Foundation

public struct SemanticTokensWorkspaceClientCapabilities: Codable, Hashable, Sendable {
    public var refreshSupport: Bool?

    public init(refreshSupport: Bool) {
        self.refreshSupport = refreshSupport
    }
}

public enum TokenFormat: String, Codable, Hashable, Sendable {
    case relative = "relative"

    public static let Relative = TokenFormat.relative
}

public struct SemanticTokensClientCapabilities: Codable, Hashable, Sendable {
    public struct Requests: Codable, Hashable, Sendable {
        public struct Range: Codable, Hashable, Sendable {
        }

        public struct Full: Codable, Hashable, Sendable {
            public var delta: Bool?

            public init(delta: Bool = true) {
                self.delta = delta
            }
        }

        public typealias RangeOption = TwoTypeOption<Bool, Range>
        public typealias FullOption = TwoTypeOption<Bool, Full>

        public var range: RangeOption
        public var full: FullOption

        public init(range: Bool = true, delta: Bool = true) {
            self.range = .optionA(range)
            self.full = .optionB(Full(delta: true))
        }
    }

    public var dynamicRegistration: Bool?
    public var requests: Requests
    public var tokenTypes: [String]
    public var tokenModifiers: [String]
    public var formats: [TokenFormat]
    public var overlappingTokenSupport: Bool?
    public var multilineTokenSupport: Bool?
    public var serverCancelSupport: Bool?
    public var augmentsSyntaxTokens: Bool?

    public init(dynamicRegistration: Bool = false,
                requests: SemanticTokensClientCapabilities.Requests = .init(range: true, delta: true),
                tokenTypes: [String] = SemanticTokenTypes.allStrings,
                tokenModifiers: [String] = SemanticTokenModifiers.allStrings,
                formats: [TokenFormat] = [TokenFormat.relative],
                overlappingTokenSupport: Bool = true,
                multilineTokenSupport: Bool = true,
                serverCancelSupport: Bool = false,
                augmentsSyntaxTokens: Bool = true) {
        self.dynamicRegistration = dynamicRegistration
        self.requests = requests
        self.tokenTypes = tokenTypes
        self.tokenModifiers = tokenModifiers
        self.formats = formats
        self.overlappingTokenSupport = overlappingTokenSupport
        self.multilineTokenSupport = multilineTokenSupport
        self.serverCancelSupport = serverCancelSupport
        self.augmentsSyntaxTokens = augmentsSyntaxTokens
    }
}

public struct SemanticTokensLegend: Codable, Hashable, Sendable {
    public var tokenTypes: [String]
    public var tokenModifiers: [String]
}

public enum SemanticTokenTypes: String, Codable, Hashable, CaseIterable, Sendable {
    case namespace = "namespace"
    case type = "type"
    case `class` = "class"
    case `enum` = "enum"
    case interface = "interface"
    case `struct` = "struct"
    case typeParameter = "typeParameter"
    case parameter = "parameter"
    case variable = "variable"
    case property = "property"
    case enumMember = "enumMember"
    case event = "event"
    case function = "function"
    case method = "method"
    case macro = "macro"
    case keyword = "keyword"
    case modifier = "modifier"
    case comment = "comment"
    case string = "string"
    case number = "number"
    case regexp = "regexp"
    case `operator` = "operator"

    public static var allStrings: [String] {
        return allCases.map({ $0.rawValue })
    }
}

public enum SemanticTokenModifiers: String, Codable, Hashable, CaseIterable, Sendable {
    case declaration = "declaration"
    case definition = "definition"
    case readonly = "readonly"
    case `static` = "static"
    case deprecated = "deprecated"
    case abstract = "abstract"
    case async = "async"
    case modification = "modification"
    case documentation = "documentation"
    case defaultLibrary = "defaultLibrary"

    public static var allStrings: [String] {
        return allCases.map({ $0.rawValue })
    }
}

public struct SemanticTokensParams: Codable, Hashable, Sendable {
    public var workDoneToken: ProgressToken?
    public var partialResultToken: ProgressToken?
    public var textDocument: TextDocumentIdentifier

    public init(textDocument: TextDocumentIdentifier) {
        self.textDocument = textDocument
    }
}

public struct SemanticTokens: Codable, Hashable, Sendable {
    public var resultId: String?
    public var data: [UInt32]
}

public typealias SemanticTokensResponse = SemanticTokens?

public struct SemanticTokensPartialResult: Codable, Hashable, Sendable {
    public var data: [UInt32]
}

public struct SemanticTokensDeltaParams: Codable, Hashable, Sendable {
    public var workDoneToken: ProgressToken?
    public var partialResultToken: ProgressToken?
    public var textDocument: TextDocumentIdentifier
    public var previousResultId: String

    public init(textDocument: TextDocumentIdentifier, previousResultId: String) {
        self.textDocument = textDocument
        self.previousResultId = previousResultId
    }
}

public struct SemanticTokensEdit: Codable, Hashable, Sendable {
    public var start: UInt
    public var deleteCount: UInt
    public var data: [UInt32]?
}

public struct SemanticTokensDelta: Codable, Hashable, Sendable {
    public var resultId: String?
    public var edits: [SemanticTokensEdit]
}

public typealias SemanticTokensDeltaResponse = TwoTypeOption<SemanticTokens, SemanticTokensDelta>?

public struct SemanticTokensRangeParams: Codable, Hashable, Sendable {
    public var workDoneToken: ProgressToken?
    public var partialResultToken: ProgressToken?
    public var textDocument: TextDocumentIdentifier
    public var range: LSPRange

    public init(textDocument: TextDocumentIdentifier, range: LSPRange) {
        self.textDocument = textDocument
        self.range = range
    }
}

public extension TwoTypeOption where T == SemanticTokens, U == SemanticTokensDelta {
	var resultId: String? {
		switch self {
		case .optionA(let token):
			return token.resultId
		case .optionB(let delta):
			return delta.resultId
		}
	}
}
