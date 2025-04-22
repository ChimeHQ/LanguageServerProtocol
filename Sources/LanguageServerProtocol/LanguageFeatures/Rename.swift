import Foundation

public enum PrepareSupportDefaultBehavior: Int, CaseIterable, Codable, Hashable, Sendable {
	case Identifier = 1
}

public struct RenameClientCapabilities: Codable, Hashable, Sendable {
	public let dynamicRegistration: Bool?
	public let prepareSupport: Bool?
	public let prepareSupportDefaultBehavior: PrepareSupportDefaultBehavior?
	public let honorsChangeAnnotations: Bool?

	public init(
		dynamicRegistration: Bool?, prepareSupport: Bool?,
		prepareSupportDefaultBehavior: PrepareSupportDefaultBehavior?,
		honorsChangeAnnotations: Bool?
	) {
		self.dynamicRegistration = dynamicRegistration
		self.prepareSupport = prepareSupport
		self.prepareSupportDefaultBehavior = prepareSupportDefaultBehavior
		self.honorsChangeAnnotations = honorsChangeAnnotations
	}
}

public struct RenameOptions: Codable, Hashable, Sendable {
	public var workDoneProgress: Bool?
	public var prepareProvider: Bool?

	public init(workDoneProgress: Bool? = nil, prepareProvider: Bool? = nil) {
		self.workDoneProgress = workDoneProgress
		self.prepareProvider = prepareProvider
	}
}

public typealias PrepareRenameParams = TextDocumentPositionParams

public struct RenameParams: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentIdentifier
	public let position: Position
	public let newName: String

	public init(textDocument: TextDocumentIdentifier, position: Position, newName: String) {
		self.textDocument = textDocument
		self.position = position
		self.newName = newName
	}
}

public struct RangeWithPlaceholder: Codable, Hashable, Sendable {
	public let range: LSPRange
	public let placeholder: String

	public init(range: LSPRange, placeholder: String) {
		self.range = range
		self.placeholder = placeholder
	}
}

public struct PrepareRenameDefaultBehavior: Codable, Hashable, Sendable {
	public let defaultBehavior: Bool

	public init(defaultBehavior: Bool) {
		self.defaultBehavior = defaultBehavior
	}
}

public typealias PrepareRenameResponse = ThreeTypeOption<
	LSPRange, RangeWithPlaceholder, PrepareRenameDefaultBehavior
>?

public typealias RenameResponse = WorkspaceEdit?
