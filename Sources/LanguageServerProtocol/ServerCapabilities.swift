import Foundation

public struct StaticRegistrationWorkDoneProgressTextDocumentRegistrationOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var textDocument: TextDocumentIdentifier
    public var position: Position
    public var documentSelector: DocumentSelector?
    public var id: String?
}

public struct PartialResultsWorkDoneProgressTextDocumentRegistrationOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var textDocument: TextDocumentIdentifier
    public var position: Position
    public var documentSelector: DocumentSelector?
    public var partialResultToken: ProgressToken?
}

public struct WorkDoneProgressOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
}

public struct SaveOptions: Codable, Hashable {
    public let includeText: Bool?
}

public enum TextDocumentSyncKind: Int, Codable, Hashable {
    case none = 0
    case full = 1
    case incremental = 2
}

public struct TextDocumentSyncOptions: Codable, Hashable {
    public var openClose: Bool?
    public var change: TextDocumentSyncKind?
    public var willSave: Bool?
    public var willSaveWaitUntil: Bool?
    public var save: TwoTypeOption<Bool, SaveOptions>?

    public var effectiveSave: SaveOptions? {
        switch save {
        case nil:
            return nil
        case .optionA(let value):
            return value ? SaveOptions(includeText: false) : nil
        case .optionB(let options):
            return options
        }
    }
}

public struct CompletionOptions: Codable, Hashable {
    public var resolveProvider: Bool?
    public var triggerCharacters: [String]
}

public typealias HoverOptions = WorkDoneProgressOptions

public struct SignatureHelpOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var triggerCharacters: [String]?
    public var retriggerCharacters: [String]?
}

public typealias DeclarationOptions = WorkDoneProgressOptions

public typealias DeclarationRegistrationOptions = StaticRegistrationWorkDoneProgressTextDocumentRegistrationOptions

public typealias DefinitionOptions = WorkDoneProgressOptions

public typealias TypeDefinitionOptions = WorkDoneProgressOptions

public typealias TypeDefinitionRegistrationOptions = PartialResultsWorkDoneProgressTextDocumentRegistrationOptions

public typealias ImplementationOptions = WorkDoneProgressOptions

public typealias ImplementationRegistrationOptions = StaticRegistrationWorkDoneProgressTextDocumentRegistrationOptions

public typealias ReferenceOptions = WorkDoneProgressOptions

public typealias DocumentHighlightOptions = WorkDoneProgressOptions

public struct DocumentSymbolOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var label: String?
}

public struct CodeActionOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var codeActionKinds: [CodeActionKind]?
    public var resolveProvider: Bool?
}

public struct CodeLensOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var resolveProvider: Bool?
}

public struct DocumentLinkOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var resolveProvider: Bool?
}

public typealias DocumentColorOptions = WorkDoneProgressOptions

public typealias DocumentColorRegistrationOptions = StaticRegistrationWorkDoneProgressTextDocumentRegistrationOptions

public typealias DocumentFormattingOptions = WorkDoneProgressOptions

public typealias DocumentRangeFormattingOptions = WorkDoneProgressOptions

public struct DocumentOnTypeFormattingOptions: Codable, Hashable {
    public var firstTriggerCharacter: String
    public var moreTriggerCharacter: [String]?
}

public typealias FoldingRangeOptions = WorkDoneProgressOptions

public typealias FoldingRangeRegistrationOptions = StaticRegistrationWorkDoneProgressTextDocumentRegistrationOptions

public struct ExecuteCommandOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var commands: [String]
}

public typealias SelectionRangeOptions = WorkDoneProgressOptions

public typealias SelectionRangeRegistrationOptions = StaticRegistrationWorkDoneProgressTextDocumentRegistrationOptions

public typealias LinkedEditingRangeOptions = WorkDoneProgressOptions

public typealias LinkedEditingRangeRegistrationOptions = StaticRegistrationWorkDoneProgressTextDocumentRegistrationOptions

public typealias CallHierarchyOptions = WorkDoneProgressOptions

public typealias CallHierarchyRegistrationOptions = StaticRegistrationWorkDoneProgressTextDocumentRegistrationOptions

public struct SemanticTokensOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var legend: SemanticTokensLegend
    public var range: SemanticTokensClientCapabilities.Requests.RangeOption
    public var full: SemanticTokensClientCapabilities.Requests.FullOption
}

public struct SemanticTokensRegistrationOptions: Codable, Hashable {
    public var documentSelector: DocumentSelector?
    public var workDoneProgress: Bool?
    public var legend: SemanticTokensLegend
    public var range: SemanticTokensClientCapabilities.Requests.RangeOption
    public var full: SemanticTokensClientCapabilities.Requests.FullOption
    public var id: String?
}

public typealias MonikerOptions = WorkDoneProgressOptions

public typealias MonikerRegistrationOptions = PartialResultsWorkDoneProgressTextDocumentRegistrationOptions

public enum FileOperationPatternKind: String, Codable, Hashable {
    case file = "file"
    case folder = "folder"
}

public struct FileOperationPatternOptions: Codable, Hashable {
    public var ignoreCase: Bool?
}

public struct FileOperationPattern: Codable, Hashable {
    public var glob: String
    public var matches: FileOperationPatternKind
    public var options: FileOperationPatternOptions
}

public struct FileOperationFilter: Codable, Hashable {
    public var scheme: String?
    public var pattern: FileOperationPattern
}

public struct FileOperationRegistrationOptions: Codable, Hashable {
    public var filters: [FileOperationFilter]
}

public struct WorkspaceFoldersServerCapabilities: Codable, Hashable {
    public var supported: Bool?
    public var changeNotifications: TwoTypeOption<String, Bool>?
}

public struct ServerCapabilities: Codable, Equatable {
    public struct Workspace: Codable, Hashable {
        public struct FileOperations: Codable, Hashable {
            public var didCreate: FileOperationRegistrationOptions?
            public var willCreate: FileOperationRegistrationOptions?
            public var didRename: FileOperationRegistrationOptions?
            public var willRename: FileOperationRegistrationOptions?
            public var didDelete: FileOperationRegistrationOptions?
            public var willDelete: FileOperationRegistrationOptions?
        }

        public var workspaceFolders: WorkspaceFoldersServerCapabilities?
        public var fileOperations: FileOperations?
    }

    public var textDocumentSync: TwoTypeOption<TextDocumentSyncOptions, TextDocumentSyncKind>?
    public var completionProvider: CompletionOptions?
    public var hoverProvider: TwoTypeOption<Bool, HoverOptions>?
    public var signatureHelpProvider: SignatureHelpOptions?
    public var declarationProvider: ThreeTypeOption<Bool, DeclarationOptions, DeclarationRegistrationOptions>?
    public var definitionProvider: TwoTypeOption<Bool, DefinitionOptions>?
    public var typeDefinitionProvider: ThreeTypeOption<Bool, TypeDefinitionOptions, TypeDefinitionRegistrationOptions>?
    public var implementationProvider: ThreeTypeOption<Bool, ImplementationOptions, ImplementationRegistrationOptions>?
    public var referencesProvider: TwoTypeOption<Bool, ReferenceOptions>?
    public var documentHighlightProvider: TwoTypeOption<Bool, DocumentHighlightOptions>?
    public var documentSymbolProvider: TwoTypeOption<Bool, DocumentSymbolOptions>?
    public var codeActionProvider: TwoTypeOption<Bool, CodeActionOptions>?
    public var codeLensProvider: CodeLensOptions?
    public var documentLinkProvider: DocumentLinkOptions?
    public var colorProvider: ThreeTypeOption<Bool, DocumentColorOptions, DocumentColorRegistrationOptions>?
    public var documentFormattingProvider: TwoTypeOption<Bool, DocumentFormattingOptions>?
    public var documentRangeFormattingProvider: TwoTypeOption<Bool, DocumentRangeFormattingOptions>?
    public var documentOnTypeFormattingProvider: DocumentOnTypeFormattingOptions?
    public var renameProvider: TwoTypeOption<Bool, RenameOptions>?
    public var foldingRangeProvider: ThreeTypeOption<Bool, FoldingRangeOptions, FoldingRangeRegistrationOptions>?
    public var executeCommandProvider: ExecuteCommandOptions?
    public var selectionRangeProvider: ThreeTypeOption<Bool, SelectionRangeOptions, SelectionRangeRegistrationOptions>?
    public var linkedEditingRangeProvider: ThreeTypeOption<Bool, LinkedEditingRangeOptions, LinkedEditingRangeRegistrationOptions>?
    public var callHierarchyProvider: ThreeTypeOption<Bool, CallHierarchyOptions, CallHierarchyRegistrationOptions>?
    public var semanticTokensProvider: TwoTypeOption<SemanticTokensOptions, SemanticTokensRegistrationOptions>?
    public var monikerProvider: ThreeTypeOption<Bool, MonikerOptions, MonikerRegistrationOptions>?
    public var workspaceSymbolProvider: TwoTypeOption<Bool, WorkspaceSymbolOptions>?
    public var workspace: Workspace?
    public var experimental: LSPAny
}
