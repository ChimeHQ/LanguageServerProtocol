import Foundation
import AnyCodable

public struct DynamicRegistrationClientCapabilities: Codable, Hashable {
    public var dynamicRegistration: Bool?

    public init(dynamicRegistration: Bool) {
        self.dynamicRegistration = dynamicRegistration
    }
}

public struct DynamicRegistrationLinkSupportClientCapabilities: Codable, Hashable {
    public var dynamicRegistration: Bool?
    public var linkSupport: Bool?

    public init(dynamicRegistration: Bool, linkSupport: Bool) {
        self.dynamicRegistration = dynamicRegistration
        self.linkSupport = linkSupport
    }
}

public enum ResourceOperationKind: String, Codable, Hashable {
    case create
    case rename
    case delete
}

public enum FailureHandlingKind: String, Codable, Hashable {
    case abort
    case transactional
    case textOnlyTransactional
    case undo
}

public struct WorkspaceClientCapabilityEdit: Codable, Hashable {
    public let documentChanges: Bool?
    public let resourceOperations: [ResourceOperationKind]
    public let failureHandling: FailureHandlingKind?

    public init(documentChanges: Bool?, resourceOperations: [ResourceOperationKind], failureHandling: FailureHandlingKind?) {
        self.documentChanges = documentChanges
        self.resourceOperations = resourceOperations
        self.failureHandling = failureHandling
    }
}

public typealias DidChangeConfigurationClientCapabilities = GenericDynamicRegistration

public typealias DidChangeWatchedFilesClientCapabilities = GenericDynamicRegistration

public struct WorkspaceClientCapabilitySymbolValueSet: Codable, Hashable {
    let valueSet: [SymbolKind]?

    public init(valueSet: [SymbolKind]?) {
        self.valueSet = valueSet
    }
}

public struct WorkspaceClientCapabilitySymbol: Codable, Hashable {
    public let dynamicRegistration: Bool?
    public let symbolKind: WorkspaceClientCapabilitySymbolValueSet?

    public init(dynamicRegistration: Bool?, symbolKind: WorkspaceClientCapabilitySymbolValueSet?) {
        self.dynamicRegistration = dynamicRegistration
        self.symbolKind = symbolKind
    }

    public init(dynamicRegistration: Bool?, symbolKind: [SymbolKind]?) {
        self.dynamicRegistration = dynamicRegistration
        self.symbolKind = WorkspaceClientCapabilitySymbolValueSet(valueSet: symbolKind)
    }
}

public struct WorkspaceClientCapabilities: Codable {
    public let applyEdit: Bool?
    public let workspaceEdit: WorkspaceClientCapabilityEdit?
    public let didChangeConfiguration: DidChangeConfigurationClientCapabilities?
    public let didChangeWatchedFiles: GenericDynamicRegistration?
    public let symbol: WorkspaceClientCapabilitySymbol?
    public let executeCommand: GenericDynamicRegistration?
    public let workspaceFolders: Bool?
    public let configuration: Bool?
    public let semanticTokens: SemanticTokensWorkspaceClientCapabilities?

    public init(applyEdit: Bool,
                workspaceEdit: WorkspaceClientCapabilityEdit?,
                didChangeConfiguration: DidChangeConfigurationClientCapabilities?,
                didChangeWatchedFiles: GenericDynamicRegistration?,
                symbol: WorkspaceClientCapabilitySymbol?,
                executeCommand: GenericDynamicRegistration?,
                workspaceFolders: Bool?,
                configuration: Bool?,
                semanticTokens: SemanticTokensWorkspaceClientCapabilities?) {
        self.applyEdit = applyEdit
        self.workspaceEdit = workspaceEdit
        self.didChangeConfiguration = didChangeConfiguration
        self.didChangeWatchedFiles = didChangeWatchedFiles
        self.symbol = symbol
        self.executeCommand = executeCommand
        self.workspaceFolders = workspaceFolders
        self.configuration = configuration
        self.semanticTokens = semanticTokens
    }
}

public struct ShowDocumentClientCapabilities: Hashable, Codable {
    public var support: Bool
}

public struct ShowMessageRequestClientCapabilities: Hashable, Codable {
    public struct MessageActionItemCapabilities: Hashable, Codable {
        public var additionalPropertiesSupport: Bool
    }

    public var messageActionItem: MessageActionItemCapabilities

    init(messageActionItem: MessageActionItemCapabilities) {
        self.messageActionItem = messageActionItem
    }
}

public struct WindowClientCapabilities: Hashable, Codable {
    public var workDoneProgress: Bool
    public var showMessage: ShowMessageRequestClientCapabilities
    public var showDocument: ShowDocumentClientCapabilities

    public init(workDoneProgress: Bool, showMessage: ShowMessageRequestClientCapabilities, showDocument: ShowDocumentClientCapabilities) {
        self.workDoneProgress = workDoneProgress
        self.showMessage = showMessage
        self.showDocument = showDocument
    }
}

public struct RegularExpressionsClientCapabilities: Hashable, Codable {
    public var engine: String
    public var version: String?

    public init(engine: String, version: String? = nil) {
        self.engine = engine
        self.version = version
    }
}

public struct MarkdownClientCapabilities: Hashable, Codable {
    public var parser: String
    public var version: String?
    public var allowedTags: [String]?

    public init(parser: String, version: String? = nil, allowedTags: [String]? = nil) {
        self.parser = parser
        self.version = version
        self.allowedTags = allowedTags
    }
}

public struct GeneralClientCapabilities: Hashable, Codable {
    public var regularExpressions: RegularExpressionsClientCapabilities?
    public var markdown: MarkdownClientCapabilities?

    public init(regularExpressions: RegularExpressionsClientCapabilities?, markdown: MarkdownClientCapabilities?) {
        self.regularExpressions = regularExpressions
        self.markdown = markdown
    }
}

public struct TextDocumentSyncClientCapabilities: Codable, Hashable {
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

public struct TextDocumentClientCapabilities: Codable, Hashable {
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
}

public struct ClientCapabilities: Codable {
    public let workspace: WorkspaceClientCapabilities?
    public let textDocument: TextDocumentClientCapabilities?
    public var window: WindowClientCapabilities?
    public var general: GeneralClientCapabilities?
    public let experimental: LSPAny

    public init(workspace: WorkspaceClientCapabilities?, textDocument: TextDocumentClientCapabilities?, window: WindowClientCapabilities?, general: GeneralClientCapabilities?, experimental: LSPAny) {
        self.workspace = workspace
        self.textDocument = textDocument
        self.window = window
        self.general = general
        self.experimental = experimental
    }
}
