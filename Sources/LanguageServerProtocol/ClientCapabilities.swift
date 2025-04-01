import Foundation

public struct DynamicRegistrationClientCapabilities: Codable, Hashable, Sendable {
	public var dynamicRegistration: Bool?

	public init(dynamicRegistration: Bool) {
		self.dynamicRegistration = dynamicRegistration
	}
}

public struct DynamicRegistrationLinkSupportClientCapabilities: Codable, Hashable, Sendable {
	public var dynamicRegistration: Bool?
	public var linkSupport: Bool?

	public init(dynamicRegistration: Bool, linkSupport: Bool) {
		self.dynamicRegistration = dynamicRegistration
		self.linkSupport = linkSupport
	}
}

public enum ResourceOperationKind: String, Codable, Hashable, Sendable {
	case create
	case rename
	case delete
}

public enum FailureHandlingKind: String, Codable, Hashable, Sendable {
	case abort
	case transactional
	case textOnlyTransactional
	case undo
}

public struct WorkspaceClientCapabilityEdit: Codable, Hashable, Sendable {
	public let documentChanges: Bool?
	public let resourceOperations: [ResourceOperationKind]
	public let failureHandling: FailureHandlingKind?

	public init(
		documentChanges: Bool?, resourceOperations: [ResourceOperationKind],
		failureHandling: FailureHandlingKind?
	) {
		self.documentChanges = documentChanges
		self.resourceOperations = resourceOperations
		self.failureHandling = failureHandling
	}
}

public typealias DidChangeConfigurationClientCapabilities = GenericDynamicRegistration

public typealias DidChangeWatchedFilesClientCapabilities = GenericDynamicRegistration

public struct ShowDocumentClientCapabilities: Hashable, Codable, Sendable {
	public var support: Bool

	public init(support: Bool) {
		self.support = support
	}
}

public struct ShowMessageRequestClientCapabilities: Hashable, Codable, Sendable {
	public struct MessageActionItemCapabilities: Hashable, Codable, Sendable {
		public var additionalPropertiesSupport: Bool?

		public init(additionalPropertiesSupport: Bool?) {
			self.additionalPropertiesSupport = additionalPropertiesSupport
		}
	}

	public var messageActionItem: MessageActionItemCapabilities?

	public init(messageActionItem: MessageActionItemCapabilities?) {
		self.messageActionItem = messageActionItem
	}
}

public struct WindowClientCapabilities: Hashable, Codable, Sendable {
	public var workDoneProgress: Bool?
	public var showMessage: ShowMessageRequestClientCapabilities?
	public var showDocument: ShowDocumentClientCapabilities?

	public init(
		workDoneProgress: Bool,
		showMessage: ShowMessageRequestClientCapabilities?,
		showDocument: ShowDocumentClientCapabilities?
	) {
		self.workDoneProgress = workDoneProgress
		self.showMessage = showMessage
		self.showDocument = showDocument
	}
}

public struct RegularExpressionsClientCapabilities: Hashable, Codable, Sendable {
	public var engine: String
	public var version: String?

	public init(engine: String, version: String? = nil) {
		self.engine = engine
		self.version = version
	}
}

public struct MarkdownClientCapabilities: Hashable, Codable, Sendable {
	public var parser: String
	public var version: String?
	public var allowedTags: [String]?

	public init(parser: String, version: String? = nil, allowedTags: [String]? = nil) {
		self.parser = parser
		self.version = version
		self.allowedTags = allowedTags
	}
}

public struct GeneralClientCapabilities: Hashable, Codable, Sendable {
	public var regularExpressions: RegularExpressionsClientCapabilities?
	public var markdown: MarkdownClientCapabilities?

	public init(
		regularExpressions: RegularExpressionsClientCapabilities?,
		markdown: MarkdownClientCapabilities?
	) {
		self.regularExpressions = regularExpressions
		self.markdown = markdown
	}
}

public struct TextDocumentSyncClientCapabilities: Codable, Hashable, Sendable {
	public let dynamicRegistration: Bool?
	public let willSave: Bool?
	public let willSaveWaitUntil: Bool?
	public let didSave: Bool?

	public init(dynamicRegistration: Bool, willSave: Bool, willSaveWaitUntil: Bool, didSave: Bool) {
		self.dynamicRegistration = dynamicRegistration
		self.willSave = willSave
		self.willSaveWaitUntil = willSaveWaitUntil
		self.didSave = didSave
	}
}

public struct TextDocumentClientCapabilities: Codable, Hashable, Sendable {
	public var synchronization: TextDocumentSyncClientCapabilities?
	public var completion: CompletionClientCapabilities?
	public var hover: HoverClientCapabilities?
	public var signatureHelp: SignatureHelpClientCapabilities?
	public var declaration: DeclarationClientCapabilities?
	public var definition: DefinitionClientCapabilities?
	public var typeDefinition: TypeDefinitionClientCapabilities?
	public var implementation: ImplementationClientCapabilities?
	public var references: ReferenceClientCapabilities?
	public var documentHighlight: DocumentHighlightClientCapabilities?
	public var documentSymbol: DocumentSymbolClientCapabilities?
	public var codeAction: CodeActionClientCapabilities?
	public var codeLens: CodeLensClientCapabilities?
	public var documentLink: DocumentLinkClientCapabilities?
	public var colorProvider: DocumentColorClientCapabilities?
	public var formatting: DocumentFormattingClientCapabilities?
	public var rangeFormatting: DocumentRangeFormattingClientCapabilities?
	public var onTypeFormatting: DocumentOnTypeFormattingClientCapabilities?
	public var rename: RenameClientCapabilities?
	public var publishDiagnostics: PublishDiagnosticsClientCapabilities?
	public var foldingRange: FoldingRangeClientCapabilities?
	public var selectionRange: SelectionRangeClientCapabilities?
	public var linkedEditingRange: LinkedEditingRangeClientCapabilities?
	public var callHierarchy: CallHierarchyClientCapabilities?
	public var semanticTokens: SemanticTokensClientCapabilities?
	public var moniker: MonikerClientCapabilities?
	public var inlayHint: InlayHintClientCapabilities?
	public var diagnostic: DiagnosticClientCapabilities?

	public init(
		synchronization: TextDocumentSyncClientCapabilities? = nil,
		completion: CompletionClientCapabilities? = nil,
		hover: HoverClientCapabilities? = nil,
		signatureHelp: SignatureHelpClientCapabilities? = nil,
		declaration: DeclarationClientCapabilities? = nil,
		definition: DefinitionClientCapabilities? = nil,
		typeDefinition: TypeDefinitionClientCapabilities? = nil,
		implementation: ImplementationClientCapabilities? = nil,
		references: ReferenceClientCapabilities? = nil,
		documentHighlight: DocumentHighlightClientCapabilities? = nil,
		documentSymbol: DocumentSymbolClientCapabilities? = nil,
		codeAction: CodeActionClientCapabilities? = nil,
		codeLens: CodeLensClientCapabilities? = nil,
		documentLink: DocumentLinkClientCapabilities? = nil,
		colorProvider: DocumentColorClientCapabilities? = nil,
		formatting: DocumentFormattingClientCapabilities? = nil,
		rangeFormatting: DocumentRangeFormattingClientCapabilities? = nil,
		onTypeFormatting: DocumentOnTypeFormattingClientCapabilities? = nil,
		rename: RenameClientCapabilities? = nil,
		publishDiagnostics: PublishDiagnosticsClientCapabilities? = nil,
		foldingRange: FoldingRangeClientCapabilities? = nil,
		selectionRange: SelectionRangeClientCapabilities? = nil,
		linkedEditingRange: LinkedEditingRangeClientCapabilities? = nil,
		callHierarchy: CallHierarchyClientCapabilities? = nil,
		semanticTokens: SemanticTokensClientCapabilities? = nil,
		moniker: MonikerClientCapabilities? = nil,
		inlayHint: InlayHintClientCapabilities? = nil,
		diagnostic: DiagnosticClientCapabilities? = nil
	) {
		self.synchronization = synchronization
		self.completion = completion
		self.hover = hover
		self.signatureHelp = signatureHelp
		self.declaration = declaration
		self.definition = definition
		self.typeDefinition = typeDefinition
		self.implementation = implementation
		self.references = references
		self.documentHighlight = documentHighlight
		self.documentSymbol = documentSymbol
		self.codeAction = codeAction
		self.codeLens = codeLens
		self.documentLink = documentLink
		self.colorProvider = colorProvider
		self.formatting = formatting
		self.rangeFormatting = rangeFormatting
		self.onTypeFormatting = onTypeFormatting
		self.rename = rename
		self.publishDiagnostics = publishDiagnostics
		self.foldingRange = foldingRange
		self.selectionRange = selectionRange
		self.linkedEditingRange = linkedEditingRange
		self.callHierarchy = callHierarchy
		self.semanticTokens = semanticTokens
		self.moniker = moniker
		self.diagnostic = diagnostic
	}
}

public struct ClientCapabilities: Codable, Hashable, Sendable {
	public struct Workspace: Codable, Hashable, Sendable {
		public struct FileOperations: Codable, Hashable, Sendable {
			public var dynamicRegistration: Bool?
			public var didCreate: Bool?
			public var willCreate: Bool?
			public var didRename: Bool?
			public var willRename: Bool?
			public var didDelete: Bool?
			public var willDelete: Bool?

			public init(
				dynamicRegistration: Bool? = nil,
				didCreate: Bool? = nil,
				willCreate: Bool? = nil,
				didRename: Bool? = nil,
				willRename: Bool? = nil,
				didDelete: Bool? = nil,
				willDelete: Bool? = nil
			) {
				self.dynamicRegistration = dynamicRegistration
				self.didCreate = didCreate
				self.willCreate = willCreate
				self.didRename = didRename
				self.willRename = willRename
				self.didDelete = didDelete
				self.willDelete = willDelete
			}
		}

		public let applyEdit: Bool?
		public let workspaceEdit: WorkspaceClientCapabilityEdit?
		public let didChangeConfiguration: DidChangeConfigurationClientCapabilities?
		public let didChangeWatchedFiles: GenericDynamicRegistration?
		public let symbol: WorkspaceSymbolClientCapabilities?
		public let executeCommand: GenericDynamicRegistration?
		public let workspaceFolders: Bool?
		public let configuration: Bool?
		public let semanticTokens: SemanticTokensWorkspaceClientCapabilities?
		public let codeLens: CodeLensWorkspaceClientCapabilities?
		public let fileOperations: FileOperations?

		public init(
			applyEdit: Bool,
			workspaceEdit: WorkspaceClientCapabilityEdit?,
			didChangeConfiguration: DidChangeConfigurationClientCapabilities?,
			didChangeWatchedFiles: GenericDynamicRegistration?,
			symbol: WorkspaceSymbolClientCapabilities?,
			executeCommand: GenericDynamicRegistration?,
			workspaceFolders: Bool?,
			configuration: Bool?,
			semanticTokens: SemanticTokensWorkspaceClientCapabilities?,
			codeLens: CodeLensWorkspaceClientCapabilities? = nil,
			fileOperations: FileOperations? = nil
		) {
			self.applyEdit = applyEdit
			self.workspaceEdit = workspaceEdit
			self.didChangeConfiguration = didChangeConfiguration
			self.didChangeWatchedFiles = didChangeWatchedFiles
			self.symbol = symbol
			self.executeCommand = executeCommand
			self.workspaceFolders = workspaceFolders
			self.configuration = configuration
			self.semanticTokens = semanticTokens
			self.codeLens = codeLens
			self.fileOperations = fileOperations
		}
	}

	public let workspace: Workspace?
	public let textDocument: TextDocumentClientCapabilities?
	public var window: WindowClientCapabilities?
	public var general: GeneralClientCapabilities?
	public let experimental: LSPAny?

	public init(
		workspace: Workspace?, textDocument: TextDocumentClientCapabilities?,
		window: WindowClientCapabilities?, general: GeneralClientCapabilities?,
		experimental: LSPAny?
	) {
		self.workspace = workspace
		self.textDocument = textDocument
		self.window = window
		self.general = general
		self.experimental = experimental
	}
}
