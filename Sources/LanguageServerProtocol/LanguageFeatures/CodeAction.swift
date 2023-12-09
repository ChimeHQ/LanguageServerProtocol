import Foundation

public typealias CodeActionKind = String

extension CodeActionKind {
	public static let Empty: CodeActionKind = ""
	public static let Quickfix: CodeActionKind = "quickfix"
	public static let Refactor: CodeActionKind = "refactor"
	public static let RefactorExtract: CodeActionKind = "refactor.extract"
	public static let RefactorInline: CodeActionKind = "refactor.inline"
	public static let RefactorRewrite: CodeActionKind = "refactor.rewrite"
	public static let Source: CodeActionKind = "source"
	public static let SourceOrganizeImports: CodeActionKind = "source.organizeImports"
	public static let SourceFixAll: CodeActionKind = "source.fixAll"
}

public struct CodeActionClientCapabilities: Codable, Hashable, Sendable {
	public struct CodeActionLiteralSupport: Codable, Hashable, Sendable {
		public var codeActionKind: ValueSet<CodeActionKind>

		public init(codeActionKind: ValueSet<CodeActionKind>) {
			self.codeActionKind = codeActionKind
		}
	}

	public struct ResolveSupport: Codable, Hashable, Sendable {
		public var properties: [String]

		public init(properties: [String]) {
			self.properties = properties
		}
	}

	public var dynamicRegistration: Bool?
	public var codeActionLiteralSupport: CodeActionLiteralSupport?
	public var isPreferredSupport: Bool?
	public var disabledSupport: Bool?
	public var dataSupport: Bool?
	public var resolveSupport: ResolveSupport?
	public var honorsChangeAnnotations: Bool?

	public init(
		dynamicRegistration: Bool?,
		codeActionLiteralSupport: CodeActionClientCapabilities.CodeActionLiteralSupport? = nil,
		isPreferredSupport: Bool? = nil,
		disabledSupport: Bool? = nil,
		dataSupport: Bool? = nil,
		resolveSupport: ResolveSupport? = nil,
		honorsChangeAnnotations: Bool? = nil
	) {
		self.dynamicRegistration = dynamicRegistration
		self.codeActionLiteralSupport = codeActionLiteralSupport
		self.isPreferredSupport = isPreferredSupport
		self.disabledSupport = disabledSupport
		self.dataSupport = dataSupport
		self.resolveSupport = resolveSupport
		self.honorsChangeAnnotations = honorsChangeAnnotations
	}
}

public struct CodeActionOptions: Codable, Hashable, Sendable {
	public var workDoneProgress: Bool?
	public var codeActionKinds: [CodeActionKind]?
	public var resolveProvider: Bool?

	public init(workDoneProgress: Bool?, codeActionKinds: [CodeActionKind]?, resolveProvider: Bool)
	{
		self.workDoneProgress = workDoneProgress
		self.codeActionKinds = codeActionKinds
		self.resolveProvider = resolveProvider
	}
}

public enum CodeActionTriggerKind: Int, Codable, Hashable, Sendable {
	case invoked = 1
	case automatic = 2
}

public struct CodeActionContext: Codable, Hashable, Sendable {
	public let diagnostics: [Diagnostic]
	public let only: [CodeActionKind]?
	public let triggerKind: CodeActionTriggerKind?

	public init(
		diagnostics: [Diagnostic], only: [CodeActionKind]?,
		triggerKind: CodeActionTriggerKind? = nil
	) {
		self.diagnostics = diagnostics
		self.only = only
		self.triggerKind = triggerKind
	}
}

public struct CodeActionParams: Codable, Hashable, Sendable {
	public let textDocument: TextDocumentIdentifier
	public let range: LSPRange
	public let context: CodeActionContext

	public init(textDocument: TextDocumentIdentifier, range: LSPRange, context: CodeActionContext) {
		self.textDocument = textDocument
		self.range = range
		self.context = context
	}
}

public struct CodeAction: Codable, Hashable, Sendable {
	public struct Disabled: Codable, Hashable, Sendable {
		public var disabled: Bool
	}

	public var title: String
	public var kind: CodeActionKind?
	public var diagnostics: [Diagnostic]?
	public var isPreferred: Bool?
	public var disabled: Disabled?
	public var edit: WorkspaceEdit?
	public var command: Command?
	public var data: LSPAny?

	public init(
		title: String, kind: CodeActionKind? = nil, diagnostics: [Diagnostic]? = nil,
		isPreferred: Bool? = nil, disabled: CodeAction.Disabled? = nil, edit: WorkspaceEdit? = nil,
		command: Command? = nil, data: LSPAny? = nil
	) {
		self.title = title
		self.kind = kind
		self.diagnostics = diagnostics
		self.isPreferred = isPreferred
		self.disabled = disabled
		self.edit = edit
		self.command = command
		self.data = data
	}
}

public typealias CodeActionResponse = [TwoTypeOption<Command, CodeAction>]?
