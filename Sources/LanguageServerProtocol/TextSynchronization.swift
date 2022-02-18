import Foundation

public struct DidOpenTextDocumentParams: Codable, Hashable {
    public let textDocument: TextDocumentItem

    public init(textDocument: TextDocumentItem) {
        self.textDocument = textDocument
    }
}

public struct TextDocumentContentChangeEvent: Codable, Hashable {
    public let range: LSPRange?
    public let rangeLength: Int?
    public let text: String

    public init(range: LSPRange?, rangeLength: Int?, text: String) {
        self.range = range
        self.rangeLength = rangeLength
        self.text = text
    }
}

public struct DidChangeTextDocumentParams: Codable, Hashable {
    public let textDocument: VersionedTextDocumentIdentifier
    public let contentChanges: [TextDocumentContentChangeEvent]

    public init(textDocument: VersionedTextDocumentIdentifier, contentChanges: [TextDocumentContentChangeEvent]) {
        self.textDocument = textDocument
        self.contentChanges = contentChanges
    }

    public init(uri: DocumentUri, version: Int, contentChanges: [TextDocumentContentChangeEvent]) {
        self.textDocument = VersionedTextDocumentIdentifier(uri: uri, version: version)
        self.contentChanges = contentChanges
    }

    public init(uri: DocumentUri, version: Int, contentChange: TextDocumentContentChangeEvent) {
        self.textDocument = VersionedTextDocumentIdentifier(uri: uri, version: version)
        self.contentChanges = [contentChange]
    }
}

public struct TextDocumentChangeRegistrationOptions: Codable, Hashable {
    public let documentSelector: DocumentSelector?
    public let syncKind: TextDocumentSyncKind
}

public struct DidSaveTextDocumentParams: Codable, Hashable {
    public let textDocument: TextDocumentIdentifier
    public let text: String?

    public init(textDocument: TextDocumentIdentifier, text: String? = nil) {
        self.textDocument = textDocument
        self.text = text
    }

    public init(uri: DocumentUri, text: String? = nil) {
        let docId = TextDocumentIdentifier(uri: uri)

        self.textDocument = docId
        self.text = text
    }
}

public struct TextDocumentSaveRegistrationOptions: Codable, Hashable {
    public let documentSelector: DocumentSelector?
    public let includeText: Bool?
}

public struct DidCloseTextDocumentParams: Codable {
    public let textDocument: TextDocumentIdentifier

    public init(textDocument: TextDocumentIdentifier) {
        self.textDocument = textDocument
    }

    public init(uri: DocumentUri) {
        let docId = TextDocumentIdentifier(uri: uri)

        self.init(textDocument: docId)
    }
}

public enum TextDocumentSaveReason: Int, Codable, Hashable {
    case manual = 1
    case afterDelay = 2
    case focusOut = 3
}

public struct WillSaveTextDocumentParams: Codable, Hashable {
    public let textDocument: TextDocumentIdentifier
    public let reason: TextDocumentSaveReason

    public init(textDocument: TextDocumentIdentifier, reason: TextDocumentSaveReason) {
        self.textDocument = textDocument
        self.reason = reason
    }
}

public typealias WillSaveWaitUntilResponse = [TextEdit]?

public struct TextEdit: Codable, Hashable {
    public let range: LSPRange
    public let newText: String

    public init(range: LSPRange, newText: String) {
        self.range = range
        self.newText = newText
    }
}

extension TextEdit: CustomStringConvertible {
    public var description: String {
        return "\(range): \"\(newText)\""
    }
}
