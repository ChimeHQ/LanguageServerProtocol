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

	public init(tokenTypes: [String], tokenModifiers: [String]) {
		self.tokenTypes = tokenTypes
		self.tokenModifiers = tokenModifiers
	}
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

// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#documentSelector
public struct SemanticToken {
	// typealias EncodedTuple = (line: UInt32, char: UInt32, length: UInt32, type: UInt32, modifiers: UInt32)

	public let line: UInt32
	public let char: UInt32
	public let length: UInt32
	public let type: UInt32
	public let modifiers: UInt32

	public static let numFields = 5

	// public func toArray() -> EncodedTuple {
	// }

	public init(line: UInt32, char: UInt32, length: UInt32, type: UInt32, modifiers: UInt32 = 0) {
		self.line = line
		self.char = char
		self.length = length
		self.type = type
		self.modifiers = modifiers
	}
}

public struct SemanticTokens: Codable, Hashable, Sendable {
	/**
	 * An optional result id. If provided and clients support delta updating
	 * the client will include the result id in the next semantic token request.
	 * A server can then instead of computing all semantic tokens again simply
	 * send a delta.
	 */
    public var resultId: String?

	/// Encoded token data
    public var data: [UInt32]


	public init(resultId: String? = nil, data: [UInt32]) {
		self.resultId = resultId
		self.data = data
	}

	func getLineTokens(_ tokens: Array<SemanticToken>.SubSequence) -> (line: UInt32, tokens: Array<SemanticToken>.SubSequence) {
		precondition(!tokens.isEmpty)

		var end = tokens.startIndex + 1
		let line = tokens[tokens.startIndex].line

		while end < tokens.endIndex && tokens[end].line == line {
			end += 1
		}

		return (line, tokens[tokens.startIndex..<end])
	}

	mutating func encodeLine(_ tokens: Array<SemanticToken>.SubSequence, prevLine: UInt32) {

		// Sort line tokens
		let sortedTokens = tokens.sorted { $0.char < $1.char }

		var prevCol: UInt32 = 0
		var prevLine = prevLine

		for i in 0..<sortedTokens.count {
			let d0 = (tokens.startIndex + i) * SemanticToken.numFields
			let t = sortedTokens[i]

			self.data[d0+0] = t.line - prevLine
			self.data[d0+1] = t.char - prevCol
			self.data[d0+2] = t.length
			self.data[d0+3] = t.type
			self.data[d0+4] = t.modifiers

			prevLine = t.line
			prevCol = t.char
		}
	}

	// Convert tokens to encoded packed array format
	// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_semanticTokens
	public init(resultId: String? = nil, tokens: [SemanticToken]) {
		self.resultId = resultId
		self.data = Array(repeating: 0, count: tokens.count * SemanticToken.numFields)
		var prevLine: UInt32 = 0

		// Process tokens one line at a time
		// Lines are assumed to be in order, but tokens within a line are implicitly
		// sorted, to make producing tokens easier for the user
		var tail = tokens[...]
		while !tail.isEmpty {
			let (line, lineTokens) = getLineTokens(tail)
			precondition(line >= prevLine, "Sematic token lines are out of order @ \(prevLine)")
			encodeLine(lineTokens, prevLine: prevLine)
			prevLine = line
			tail = tail[lineTokens.endIndex...]
		}
	}

	// Convert encoded packed array format to SemanticToken array
	// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_semanticTokens
	public func decode() -> [SemanticToken] {
		var tokens: [SemanticToken] = []

		var currentRow: UInt32 = 0
		var currentCol: UInt32 = 0
		let numTokens = data.count/5
		tokens.reserveCapacity(numTokens)

		for n in 0..<numTokens {
			let i = n * 5

			// Check if new line
			if data[i] > 0 {
				currentCol = 0
			}

			let token = SemanticToken(
				line: data[i] + currentRow,
				char: data[i+1] + currentCol,
				length: data[i+2],
				type: data[i+3],
				modifiers: data[i+4]
			)

			tokens.append(token)
			currentRow += data[i]
			currentCol += data[i+1]
		}

		return tokens
	}
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
