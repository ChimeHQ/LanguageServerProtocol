import JSONRPC

typealias UnusedResult = String?
typealias UnusedParam = String?

public enum ClientNotification {
    public enum Method: String {
        case initialized
        case exit
        case workspaceDidChangeWatchedFiles = "workspace/didChangeWatchedFiles"
        case workspaceDidChangeConfiguration = "workspace/didChangeConfiguration"
        case workspaceDidChangeWorkspaceFolders = "workspace/didChangeWorkspaceFolders"
        case workspaceDidCreateFiles = "workspace/didCreateFiles"
        case workspaceDidRenameFiles = "workspace/didRenameFiles"
        case workspaceDidDeleteFiles = "workspace/didDeleteFiles"
        case textDocumentDidOpen = "textDocument/didOpen"
        case textDocumentDidChange = "textDocument/didChange"
        case textDocumentDidClose = "textDocument/didClose"
        case textDocumentWillSave = "textDocument/willSave"
        case textDocumentDidSave = "textDocument/didSave"
        case protocolCancelRequest = "$/cancelRequest"
        case protocolSetTrace = "$/setTrace"
    }

    case initialized(InitializedParams)
    case exit
    case textDocumentDidChange(DidChangeTextDocumentParams)
    case didOpenTextDocument(DidOpenTextDocumentParams)
    case didChangeTextDocument(DidChangeTextDocumentParams)
    case didCloseTextDocument(DidCloseTextDocumentParams)
    case willSaveTextDocument(WillSaveTextDocumentParams)
    case didSaveTextDocument(DidSaveTextDocumentParams)
    case didChangeWatchedFiles(DidChangeWatchedFilesParams)
    case protocolCancelRequest(CancelParams)
    case protocolSetTrace(SetTraceParams)
    case workspaceDidChangeWorkspaceFolders(DidChangeWorkspaceFoldersParams)
    case workspaceDidChangeConfiguration(DidChangeConfigurationParams)
    case workspaceDidCreateFiles(CreateFilesParams)
    case workspaceDidRenameFiles(RenameFilesParams)
    case workspaceDidDeleteFiles(DeleteFilesParams)

    public var method: Method {
        switch self {
        case .initialized:
            return .initialized
        case .exit:
            return .exit
        case .textDocumentDidChange:
            return .textDocumentDidChange
        case .didOpenTextDocument:
            return .textDocumentDidOpen
        case .didCloseTextDocument:
            return .textDocumentDidClose
        case .willSaveTextDocument:
            return .textDocumentWillSave
        case .didChangeTextDocument:
            return .textDocumentDidChange
        case .didSaveTextDocument:
            return .textDocumentDidSave
        case .didChangeWatchedFiles:
            return .workspaceDidChangeWatchedFiles
        case .protocolCancelRequest:
            return .protocolCancelRequest
        case .protocolSetTrace:
            return .protocolSetTrace
        case .workspaceDidChangeWorkspaceFolders:
            return .workspaceDidChangeWorkspaceFolders
        case .workspaceDidChangeConfiguration:
            return .workspaceDidChangeConfiguration
        case .workspaceDidCreateFiles:
            return .workspaceDidCreateFiles
        case .workspaceDidRenameFiles:
            return .workspaceDidRenameFiles
        case .workspaceDidDeleteFiles:
            return .workspaceDidDeleteFiles
        }
    }
}

public enum ClientRequest {
    public enum Method: String {
        case initialize
        case shutdown
        case workspaceExecuteCommand = "workspace/executeCommand"
        case workspaceWillCreateFiles = "workspace/willCreateFiles"
        case workspaceWillRenameFiles = "workspace/willRenameFiles"
        case workspaceWillDeleteFiles = "workspace/willDeleteFiles"
        case workspaceSymbol = "workspace/symbol"
        case workspaceSymbolResolve = "workspaceSymbol/resolve"
        case textDocumentWillSaveWaitUntil = "textDocument/willSaveWaitUntil"
        case textDocumentCompletion = "textDocument/completion"
        case completionItemResolve = "completionItem/resolve"
        case textDocumentHover = "textDocument/hover"
        case textDocumentSignatureHelp = "textDocument/signatureHelp"
        case textDocumentDeclaration = "textDocument/declaration"
        case textDocumentDefinition = "textDocument/definition"
        case textDocumentTypeDefinition = "textDocument/typeDefinition"
        case textDocumentImplementation = "textDocument/implementation"
        case textDocumentReferences = "textDocument/references"
        case textDocumentDocumentHighlight = "textDocument/documentHighlight"
        case textDocumentDocumentSymbol = "textDocument/documentSymbol"
        case textDocumentCodeAction = "textDocument/codeAction"
        case codeLensResolve = "codeLens/resolve"
        case textDocumentCodeLens = "textDocument/codeLens"
        case textDocumentDocumentLink = "textDocument/documentLink"
        case documentLinkResolve = "documentLink/resolve"
        case textDocumentDocumentColor = "textDocument/documentColor"
        case textDocumentColorPresentation = "textDocument/colorPresentation"
        case textDocumentFormatting = "textDocument/formatting"
        case textDocumentRangeFormatting = "textDocument/rangeFormatting"
        case textDocumentOnTypeFormatting = "textDocument/onTypeFormatting"
        case textDocumentRename = "textDocument/rename"
        case textDocumentPrepareRename = "textDocument/prepareRename"
		case textDocumentPrepareCallHeirarchy = "textDocument/prepareCallHierarchy"
        case textDocumentFoldingRange = "textDocument/foldingRange"
        case textDocumentSelectionRange = "textDocument/selectionRange"
        case textDocumentLinkedEditingRange = "textDocument/linkedEditingRange"
        case textDocumentSemanticTokens = "textDocument/semanticTokens"
        case textDocumentSemanticTokensRange = "textDocument/semanticTokens/range"
        case textDocumentSemanticTokensFull = "textDocument/semanticTokens/full"
        case textDocumentSemanticTokensFullDelta = "textDocument/semanticTokens/full/delta"
        case textDocumentMoniker = "textDocument/moniker"
		case callHeirarchyIncomingCalls = "callHierarchy/incomingCalls"
		case callHeirarchyOutgoingCalls = "callHierarchy/outgoingCalls"
        case custom
    }

    case initialize(InitializeParams)
    case shutdown
    case workspaceExecuteCommand(ExecuteCommandParams)
    case workspaceWillCreateFiles(CreateFilesParams)
    case workspaceWillRenameFiles(RenameFilesParams)
    case workspaceWillDeleteFiles(DeleteFilesParams)
    case workspaceSymbol(WorkspaceSymbolParams)
    case workspaceSymbolResolve(WorkspaceSymbol)
    case willSaveWaitUntilTextDocument(WillSaveTextDocumentParams)
    case completion(CompletionParams)
    case completionItemResolve(CompletionItem)
    case hover(TextDocumentPositionParams)
    case signatureHelp(TextDocumentPositionParams)
    case declaration(TextDocumentPositionParams)
    case definition(TextDocumentPositionParams)
    case typeDefinition(TextDocumentPositionParams)
    case implementation(TextDocumentPositionParams)
    case documentHighlight(DocumentHighlightParams)
    case documentSymbol(DocumentSymbolParams)
    case codeAction(CodeActionParams)
    case codeLens(CodeLensParams)
    case codeLensResolve(CodeLens)
    case selectionRange(SelectionRangeParams)
	case prepareCallHeirarchy(CallHierarchyPrepareParams)
    case prepareRename(PrepareRenameParams)
    case rename(RenameParams)
    case documentLink(DocumentLinkParams)
    case documentLinkResolve(DocumentLink)
    case documentColor(DocumentColorParams)
    case colorPresentation(ColorPresentationParams)
    case formatting(DocumentFormattingParams)
    case rangeFormatting(DocumentRangeFormattingParams)
    case onTypeFormatting(DocumentOnTypeFormattingParams)
    case references(ReferenceParams)
    case foldingRange(FoldingRangeParams)
    case semanticTokensFull(SemanticTokensParams)
    case semanticTokensFullDelta(SemanticTokensDeltaParams)
    case semanticTokensRange(SemanticTokensRangeParams)
	case callHeirarchyIncomingCalls(CallHierarchyIncomingCallsParams)
	case callHeirarchyOutgoingCalls(CallHierarchyOutgoingCallsParams)
    case custom(String, LSPAny)

    public var method: Method {
        switch self {
        case .initialize:
            return .initialize
        case .shutdown:
            return .shutdown
        case .workspaceExecuteCommand:
            return .workspaceExecuteCommand
        case .workspaceWillCreateFiles:
            return .workspaceWillCreateFiles
        case .workspaceWillRenameFiles:
            return .workspaceWillRenameFiles
        case .workspaceWillDeleteFiles:
            return .workspaceWillDeleteFiles
        case .workspaceSymbol:
            return .workspaceSymbol
        case .workspaceSymbolResolve:
            return .workspaceSymbolResolve
        case .willSaveWaitUntilTextDocument:
            return .textDocumentWillSaveWaitUntil
        case .completion:
            return .textDocumentCompletion
        case .completionItemResolve:
            return .completionItemResolve
        case .hover:
            return .textDocumentHover
        case .signatureHelp:
            return .textDocumentSignatureHelp
        case .declaration:
            return .textDocumentDeclaration
        case .definition:
            return .textDocumentDefinition
        case .typeDefinition:
            return .textDocumentTypeDefinition
        case .implementation:
            return .textDocumentImplementation
        case .documentHighlight:
            return .textDocumentDocumentHighlight
        case .documentSymbol:
            return .textDocumentDocumentSymbol
        case .codeAction:
            return .textDocumentCodeAction
        case .codeLens:
            return .textDocumentCodeLens
        case .codeLensResolve:
            return .codeLensResolve
        case .selectionRange:
            return .textDocumentSelectionRange
		case .prepareCallHeirarchy:
			return .textDocumentPrepareCallHeirarchy
        case .prepareRename:
            return .textDocumentPrepareRename
        case .rename:
            return .textDocumentRename
        case .documentLink:
            return .textDocumentDocumentLink
        case .documentLinkResolve:
            return .documentLinkResolve
        case .documentColor:
            return .textDocumentDocumentColor
        case .colorPresentation:
            return .textDocumentColorPresentation
        case .formatting:
            return .textDocumentFormatting
        case .rangeFormatting:
            return .textDocumentRangeFormatting
        case .onTypeFormatting:
            return .textDocumentOnTypeFormatting
        case .references:
            return .textDocumentReferences
        case .foldingRange:
            return .textDocumentFoldingRange
        case .semanticTokensFull:
            return .textDocumentSemanticTokensFull
        case .semanticTokensFullDelta:
            return .textDocumentSemanticTokensFullDelta
        case .semanticTokensRange:
            return .textDocumentSemanticTokensRange
		case .callHeirarchyIncomingCalls:
			return .callHeirarchyIncomingCalls
		case .callHeirarchyOutgoingCalls:
			return .callHeirarchyOutgoingCalls
        case .custom:
            return .custom
        }
    }
}

public enum ServerNotification {
    public enum Method: String {
        case windowLogMessage = "window/logMessage"
        case windowShowMessage = "window/showMessage"
        case textDocumentPublishDiagnostics = "textDocument/publishDiagnostics"
        case telemetryEvent = "telemetry/event"
        case protocolCancelRequest = "$/cancelRequest"
        case protocolProgress = "$/progress"
        case protocolLogTrace = "$/logTrace"
    }

    case windowLogMessage(LogMessageParams)
    case windowShowMessage(ShowMessageParams)
    case textDocumentPublishDiagnostics(PublishDiagnosticsParams)
    case telemetryEvent(LSPAny)
    case protocolCancelRequest(CancelParams)
    case protocolProgress(ProgressParams)
    case protocolLogTrace(LogTraceParams)

    public var method: Method {
        switch self {
        case .windowLogMessage:
            return .windowLogMessage
        case .windowShowMessage:
            return .windowShowMessage
        case .textDocumentPublishDiagnostics:
            return .textDocumentPublishDiagnostics
        case .telemetryEvent:
            return .telemetryEvent
        case .protocolCancelRequest:
            return .protocolCancelRequest
        case .protocolProgress:
            return .protocolProgress
        case .protocolLogTrace:
            return .protocolLogTrace
        }
    }
}

public enum ServerRequest {
    public enum Method: String {
        case workspaceConfiguration = "workspace/configuration"
        case workspaceFolders = "workspace/workspaceFolders"
        case workspaceApplyEdit = "workspace/applyEdit"
        case clientRegisterCapability = "client/registerCapability"
        case clientUnregisterCapability = "client/unregisterCapability"
        case workspaceCodeLensRefresh = "workspace/codeLens/refresh"
        case workspaceSemanticTokenRefresh = "workspace/semanticTokens/refresh"
        case windowShowMessageRequest = "window/showMessageRequest"
        case windowShowDocument = "window/showDocument"
        case windowWorkDoneProgressCreate = "window/workDoneProgress/create"
        case windowWorkDoneProgressCancel = "window/workDoneProgress/cancel"
    }

    case workspaceConfiguration(ConfigurationParams)
    case workspaceFolders
    case workspaceApplyEdit(ApplyWorkspaceEditParams)
    case clientRegisterCapability(RegistrationParams)
    case clientUnregisterCapability(UnregistrationParams)
    case workspaceCodeLensRefresh
    case workspaceSemanticTokenRefresh
    case windowShowMessageRequest(ShowMessageRequestParams)
    case windowShowDocument(ShowDocumentParams)
    case windowWorkDoneProgressCreate(WorkDoneProgressCreateParams)
    case windowWorkDoneProgressCancel(WorkDoneProgressCancelParams)

    public var method: Method {
        switch self {
        case .workspaceConfiguration:
            return .workspaceConfiguration
        case .workspaceFolders:
            return .workspaceFolders
        case .workspaceApplyEdit:
            return .workspaceApplyEdit
        case .clientRegisterCapability:
            return .clientRegisterCapability
        case .clientUnregisterCapability:
            return .clientUnregisterCapability
        case .workspaceCodeLensRefresh:
            return .workspaceCodeLensRefresh
        case .workspaceSemanticTokenRefresh:
            return .workspaceSemanticTokenRefresh
        case .windowShowMessageRequest:
            return .windowShowMessageRequest
        case .windowShowDocument:
            return .windowShowDocument
        case .windowWorkDoneProgressCreate:
            return .windowWorkDoneProgressCreate
        case .windowWorkDoneProgressCancel:
            return .windowWorkDoneProgressCancel
        }
    }
}

public enum ServerRegistration {
    public enum Method: String {
        case workspaceDidChangeWatchedFiles = "workspace/didChangeWatchedFiles"
        case workspaceDidChangeConfiguration = "workspace/didChangeConfiguration"
        case workspaceDidChangeWorkspaceFolders = "workspace/didChangeWorkspaceFolders"

        case textDocumentSemanticTokens = "textDocument/semanticTokens"
    }

    case workspaceDidChangeWatchedFiles(DidChangeWatchedFilesRegistrationOptions)
    case textDocumentSemanticTokens(SemanticTokensRegistrationOptions)
    case workspaceDidChangeConfiguration
    case workspaceDidChangeWorkspaceFolders

    public var method: Method {
        switch self {
        case .workspaceDidChangeWatchedFiles:
            return .workspaceDidChangeWatchedFiles
        case .textDocumentSemanticTokens:
            return .textDocumentSemanticTokens
        case .workspaceDidChangeConfiguration:
            return .workspaceDidChangeConfiguration
        case .workspaceDidChangeWorkspaceFolders:
            return .workspaceDidChangeWorkspaceFolders
        }
    }
}
