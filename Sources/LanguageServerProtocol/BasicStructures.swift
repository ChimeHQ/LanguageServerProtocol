import Foundation
import JSONRPC

public struct Position: Codable, Hashable, Sendable {
    static let zero = Position(line: 0, character: 0)

    public let line: Int
    public let character: Int

    public init(line: Int, character: Int) {
        self.line = line
        self.character = character
    }

    public init(_ pair: (Int, Int)) {
        self.line = pair.0
        self.character = pair.1
    }
}

extension Position: CustomStringConvertible {
    public var description: String {
        return "{\(line), \(character)}"
    }
}

extension Position: Comparable {
    public static func < (lhs: Position, rhs: Position) -> Bool {
        if lhs.line == rhs.line {
            return lhs.character < rhs.character
        }

        return lhs.line < rhs.line
    }
}

public struct LSPRange: Codable, Hashable, Sendable {
    static let zero = LSPRange(start: .zero, end: .zero)

    public let start: Position
    public let end: Position

    public init(start: Position, end: Position) {
        self.start = start
        self.end = end
    }

    public init(startPair: (Int, Int), endPair: (Int, Int)) {
        self.start = Position(startPair)
        self.end = Position(endPair)
    }

    public func contains(_ position: Position) -> Bool {
        return position > start && position < end
    }

    public func intersects(_ other: LSPRange) -> Bool {
        return contains(other.start) || contains(other.end)
    }

    public var isEmpty: Bool {
        return start == end
    }
}

extension LSPRange: CustomStringConvertible {
    public var description: String {
        return "(\(start), \(end))"
    }
}

public struct TextDocumentItem: Codable, Hashable {
    public let uri: DocumentUri
    public let languageId: String
    public let version: Int
    public let text: String

    public init(uri: DocumentUri, languageId: LanguageIdentifier, version: Int, text: String) {
        self.uri = uri
		self.languageId = languageId.rawValue
        self.version = version
        self.text = text
    }

	public init(uri: DocumentUri, languageId: String, version: Int, text: String) {
		self.uri = uri
		self.languageId = languageId
		self.version = version
		self.text = text
	}
}

public struct VersionedTextDocumentIdentifier: Codable, Hashable {
    public let uri: DocumentUri
    public let version: Int?

    public init(uri: DocumentUri, version: Int?) {
        self.uri = uri
        self.version = version
    }
}

extension VersionedTextDocumentIdentifier: CustomStringConvertible {
    public var description: String {
        let vString = version.map { String($0) } ?? "<unknown>"

        return "\(uri.description): Version \(vString)"
    }
}

public struct Location: Codable, Hashable, Sendable {
    public let uri: DocumentUri
    public let range: LSPRange
}

public struct Command: Codable, Hashable, Sendable {
    public let title: String
    public let command: String
    public let arguments: [LSPAny]?
}

public enum SymbolKind: Int, CaseIterable, Hashable, Codable, Sendable {
    case file = 1
    case module = 2
    case namespace = 3
    case package = 4
    case `class` = 5
    case method = 6
    case property = 7
    case field = 8
    case constructor = 9
    case `enum` = 10
    case interface = 11
    case function = 12
    case variable = 13
    case constant = 14
    case string = 15
    case number = 16
    case boolean = 17
    case array = 18
    case object = 19
    case key = 20
    case null = 21
    case enumMember = 22
    case `struct` = 23
    case event = 24
    case `operator` = 25
    case typeParameter = 26
}

public enum MarkupKind: String, Codable, Hashable, Sendable {
    case plaintext
    case markdown
}

public struct TextDocumentPositionParams: Codable, Hashable {
    public let textDocument: TextDocumentIdentifier
    public let position: Position

    public init(textDocument: TextDocumentIdentifier, position: Position) {
        self.textDocument = textDocument
        self.position = position
    }

    public init(uri: DocumentUri, position: Position) {
        let textDocId = TextDocumentIdentifier(uri: uri)

        self.init(textDocument: textDocId, position: position)
    }
}

public struct LanguageStringPair: Codable, Hashable {
    public let language: LanguageIdentifier
    public let value: String
}

public typealias MarkedString = TwoTypeOption<String, LanguageStringPair>

public extension MarkedString {
    var value: String {
        switch self {
        case .optionA(let string):
            return string
        case .optionB(let pair):
            return pair.value
        }
    }
}

public struct MarkupContent: Codable, Hashable {
    public let kind: MarkupKind
    public let value: String
}

public struct LocationLink: Codable, Hashable {
    public let originSelectionRange: LSPRange?
    public let targetUri: String
    public let targetRange: LSPRange
    public let targetSelectionRange: LSPRange
}
