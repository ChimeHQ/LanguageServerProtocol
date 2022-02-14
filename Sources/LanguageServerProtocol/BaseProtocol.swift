import Foundation
import AnyCodable
import SwiftLSPClient

public typealias LSPAny = AnyCodable?

public typealias URI = String

public struct CancelParams: Hashable, Codable {
    public var id: TwoTypeOption<Int, String>

    public init(id: Int) {
        self.id = .optionA(id)
    }

    public init(id: String) {
        self.id = .optionB(id)
    }
}

public struct ProgressParams: Hashable, Codable {
    public var token: ProgressToken
    public var value: LSPAny
}

public struct LogTraceParams: Hashable, Codable {
    public var string: String
    public var verbose: String?
}

public enum TraceValue: String, Hashable, Codable {
    case off
    case messages
    case verbose
}

public struct SetTraceParams: Hashable, Codable {
    public var value: TraceValue

    public init(value: TraceValue) {
        self.value = value
    }
}

public struct ValueSet<T: Hashable & Codable>: Hashable, Codable {
    public var valueSet: [T]

    public init(valueSet: [T]) {
        self.valueSet = valueSet
    }

    public init(value: T) {
        self.valueSet = [value]
    }
}

public enum LanguageIdentifier: String, Codable, CaseIterable {
    case go = "go"
    case json = "json"
    case swift = "swift"
    case c = "c"
    case cpp = "cpp"
    case objc = "objective-c"
    case objcpp = "objective-cpp"
    case rust = "rust"

    static let fileExtensions = [
        "go": .go,
        "json": .json,
        "swift": .swift,
        "c": c,
        "C": .cpp,
        "cc": .cpp,
        "cpp": .cpp,
        "m": .objc,
        "mm": .objcpp,
        "h": .objcpp,
        "hpp": .objcpp,
        "rs": .rust,
    ]

    public enum LanguageServerParameterError: Error {
        case unsupportedFileExtension(String)
    }

    public init(for url: URL) throws {
        let ext = url.pathExtension
        guard let languageID =
            LanguageIdentifier.fileExtensions[ext] else {
            throw LanguageServerParameterError
                .unsupportedFileExtension("Unsupported file extension \(ext)")
        }
        self = languageID
    }
}

public struct DocumentFilter: Codable, Hashable {
    public let language: LanguageIdentifier?
    public let scheme: String?
    public let pattern: String?
}

public typealias DocumentSelector = [DocumentFilter]

public struct TextDocumentIdentifier {
    public var uri: DocumentUri

    public init(uri: DocumentUri) {
        self.uri = uri
    }

    public init(path: String) {
        self.uri = URL(fileURLWithPath: path).absoluteString
    }
}

extension TextDocumentIdentifier: Codable {
}

extension TextDocumentIdentifier: Hashable {
}

extension TextDocumentIdentifier: CustomStringConvertible {
    public var description: String {
        return uri.description
    }
}
