import Foundation

public struct DidOpenTextDocumentParams: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentItem

	public init(textDocument: TextDocumentItem) {
		self.textDocument = textDocument
	}
}

public struct TextDocumentContentChangeEvent: Codable, Hashable, Sendable {
	public let range: LSPRange?
	public let rangeLength: Int?
	public let text: String

	public init(range: LSPRange?, rangeLength: Int?, text: String) {
		self.range = range
		self.rangeLength = rangeLength
		self.text = text
	}
}

public struct DidChangeTextDocumentParams: Codable, Hashable, Sendable {
	public let textDocument: VersionedTextDocumentIdentifier
	public let contentChanges: [TextDocumentContentChangeEvent]

	public init(
		textDocument: VersionedTextDocumentIdentifier,
		contentChanges: [TextDocumentContentChangeEvent]
	) {
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

public struct TextDocumentChangeRegistrationOptions: Codable, Hashable, Sendable {
	public let documentSelector: DocumentSelector?
	public let syncKind: TextDocumentSyncKind

	public init(
		documentSelector: DocumentSelector?,
		syncKind: TextDocumentSyncKind
	) {
		self.documentSelector = documentSelector
		self.syncKind = syncKind
	}
}

public struct DidSaveTextDocumentParams: Codable, Hashable, Sendable {
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

public struct TextDocumentSaveRegistrationOptions: Codable, Hashable, Sendable {
	public let documentSelector: DocumentSelector?
	public let includeText: Bool?

	public init(
		documentSelector: DocumentSelector?,
		includeText: Bool? = nil
	) {
		self.documentSelector = documentSelector
		self.includeText = includeText
	}
}

public struct DidCloseTextDocumentParams: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentIdentifier

	public init(textDocument: TextDocumentIdentifier) {
		self.textDocument = textDocument
	}

	public init(uri: DocumentUri) {
		let docId = TextDocumentIdentifier(uri: uri)

		self.init(textDocument: docId)
	}
}

public enum TextDocumentSaveReason: Int, Codable, Hashable, Sendable {
	case manual = 1
	case afterDelay = 2
	case focusOut = 3
}

public struct WillSaveTextDocumentParams: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentIdentifier
	public let reason: TextDocumentSaveReason

	public init(textDocument: TextDocumentIdentifier, reason: TextDocumentSaveReason) {
		self.textDocument = textDocument
		self.reason = reason
	}
}

public typealias WillSaveWaitUntilResponse = [TextEdit]?

/// A special text edit to provide an insert and a replace operation.
///
/// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#insertReplaceEdit
public struct InsertReplaceEdit: Codable, Hashable, Sendable {
    public let newText: String
    public let insert: LSPRange
    public let replace: LSPRange

    public init(newText: String, insert: LSPRange, replace: LSPRange) {
		self.newText = newText
		self.insert = insert
		self.replace = replace
	}
}

public struct TextEdit: Codable, Hashable, Sendable {
	public let range: LSPRange
	public let newText: String

	public init(range: LSPRange, newText: String) {
		self.range = range
		self.newText = newText
	}

	public var isNoOp: Bool {
		return range.isEmpty && newText.isEmpty
	}

	public var isInsert: Bool {
		return range.isEmpty && (newText.isEmpty == false)
	}

	/// Adjusts the input array so that it can be applied, in order
	/// to produce the desired final state
	///
	/// This function *requires* the input edits to meet the LSP spec. In
	/// particular:
	/// - overlaps are not allowed
	/// - inserts with the same starting location must be applied in the order
	///   they appear in the array.
	public static func makeApplicable(_ edits: [TextEdit]) -> [TextEdit] {
		var finalEdits = [TextEdit]()

		for edit in edits {
			if edit.isNoOp {
				continue
			}

			guard let last = finalEdits.last else {
				finalEdits.append(edit)
				continue
			}

			guard edit.isInsert && last.isInsert && edit.range == last.range else {
				finalEdits.append(edit)
				continue
			}

			let combinedEdit = TextEdit(
				range: edit.range,
				newText: last.newText + edit.newText)

			finalEdits.removeLast()
			finalEdits.append(combinedEdit)
		}

		return finalEdits.sorted(by: {
			return $1.range.start < $0.range.start
		})
	}
}

extension TextEdit: CustomStringConvertible {
	public var description: String {
		return "\(range): \"\(newText)\""
	}
}
