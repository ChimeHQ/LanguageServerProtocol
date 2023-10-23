import JSONRPC

typealias UnusedResult = String?
typealias UnusedParam = String?

public enum ClientNotification: Sendable, Hashable {
    public enum Method: String, Hashable, Sendable {
        case initialized
        case exit
		case windowWorkDoneProgressCancel = "window/workDoneProgress/cancel"
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
	case windowWorkDoneProgressCancel(WorkDoneProgressCancelParams)
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
		case .windowWorkDoneProgressCancel:
			return .windowWorkDoneProgressCancel
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

public enum ClientRequest: Sendable, Hashable {
	public enum Method: String, Hashable, Sendable {
        case initialize
        case shutdown
        case workspaceExecuteCommand = "workspace/executeCommand"
		case workspaceInlayHintRefresh = "workspace/inlayHint/refresh"
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
		case codeActionResolve = "codeAction/resolve"
        case codeLensResolve = "codeLens/resolve"
        case textDocumentCodeLens = "textDocument/codeLens"
		case textDocumentDiagnostic = "textDocument/diagnostic"
        case textDocumentDocumentLink = "textDocument/documentLink"
        case documentLinkResolve = "documentLink/resolve"
        case textDocumentDocumentColor = "textDocument/documentColor"
        case textDocumentColorPresentation = "textDocument/colorPresentation"
        case textDocumentFormatting = "textDocument/formatting"
        case textDocumentRangeFormatting = "textDocument/rangeFormatting"
        case textDocumentOnTypeFormatting = "textDocument/onTypeFormatting"
        case textDocumentRename = "textDocument/rename"
		case textDocumentInlayHint = "textDocument/inlayHint"
		case inlayHintResolve = "inlayHint/resolve"
        case textDocumentPrepareRename = "textDocument/prepareRename"
		case textDocumentPrepareCallHierarchy = "textDocument/prepareCallHierarchy"
        case textDocumentFoldingRange = "textDocument/foldingRange"
        case textDocumentSelectionRange = "textDocument/selectionRange"
        case textDocumentLinkedEditingRange = "textDocument/linkedEditingRange"
        case textDocumentSemanticTokens = "textDocument/semanticTokens"
        case textDocumentSemanticTokensRange = "textDocument/semanticTokens/range"
        case textDocumentSemanticTokensFull = "textDocument/semanticTokens/full"
        case textDocumentSemanticTokensFullDelta = "textDocument/semanticTokens/full/delta"
        case textDocumentMoniker = "textDocument/moniker"
		case callHierarchyIncomingCalls = "callHierarchy/incomingCalls"
		case callHierarchyOutgoingCalls = "callHierarchy/outgoingCalls"
        case custom
    }

	case initialize(InitializeParams)
	case shutdown
	case workspaceExecuteCommand(ExecuteCommandParams)
	case workspaceInlayHintRefresh
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
	case diagnostics(DocumentDiagnosticParams)
	case documentHighlight(DocumentHighlightParams)
	case documentSymbol(DocumentSymbolParams)
	case codeAction(CodeActionParams)
	case codeActionResolve(CodeAction)
	case codeLens(CodeLensParams)
	case codeLensResolve(CodeLens)
	case selectionRange(SelectionRangeParams)
	case prepareCallHierarchy(CallHierarchyPrepareParams)
	case prepareRename(PrepareRenameParams)
	case rename(RenameParams)
	case inlayHint(InlayHintParams)
	case inlayHintResolve(InlayHint)
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
	case callHierarchyIncomingCalls(CallHierarchyIncomingCallsParams)
	case callHierarchyOutgoingCalls(CallHierarchyOutgoingCallsParams)
	case custom(String, LSPAny)

    public var method: Method {
        switch self {
        case .initialize:
            return .initialize
        case .shutdown:
            return .shutdown
        case .workspaceExecuteCommand:
            return .workspaceExecuteCommand
		case .workspaceInlayHintRefresh:
			return .workspaceInlayHintRefresh
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
		case .codeActionResolve:
			return .codeActionResolve
        case .codeLens:
            return .textDocumentCodeLens
        case .codeLensResolve:
            return .codeLensResolve
        case .selectionRange:
            return .textDocumentSelectionRange
		case .prepareCallHierarchy:
			return .textDocumentPrepareCallHierarchy
        case .prepareRename:
            return .textDocumentPrepareRename
        case .rename:
            return .textDocumentRename
		case .inlayHint:
			return .textDocumentInlayHint
		case .inlayHintResolve:
			return .inlayHintResolve
        case .documentLink:
            return .textDocumentDocumentLink
        case .documentLinkResolve:
            return .documentLinkResolve
        case .documentColor:
            return .textDocumentDocumentColor
		case .diagnostics:
			return .textDocumentDiagnostic
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
		case .callHierarchyIncomingCalls:
			return .callHierarchyIncomingCalls
		case .callHierarchyOutgoingCalls:
			return .callHierarchyOutgoingCalls
        case .custom:
            return .custom
        }
    }
}

public enum ServerNotification: Sendable, Hashable {
    public enum Method: String, Hashable, Sendable {
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

public enum ServerRequest: Sendable {
	public typealias Handler<T: Sendable & Encodable> = @Sendable (Result<T, AnyJSONRPCResponseError>) async -> Void
	public typealias ErrorOnlyHandler = @Sendable (AnyJSONRPCResponseError?) async -> Void

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
    }

    case workspaceConfiguration(ConfigurationParams, Handler<[LSPAny]>)
    case workspaceFolders(Handler<WorkspaceFoldersResponse>)
    case workspaceApplyEdit(ApplyWorkspaceEditParams, Handler<ApplyWorkspaceEditResult>)
    case clientRegisterCapability(RegistrationParams, ErrorOnlyHandler)
    case clientUnregisterCapability(UnregistrationParams, ErrorOnlyHandler)
    case workspaceCodeLensRefresh(ErrorOnlyHandler)
    case workspaceSemanticTokenRefresh(ErrorOnlyHandler)
    case windowShowMessageRequest(ShowMessageRequestParams, Handler<ShowMessageRequestResponse>)
    case windowShowDocument(ShowDocumentParams, Handler<ShowDocumentResult>)
	case windowWorkDoneProgressCreate(WorkDoneProgressCreateParams, ErrorOnlyHandler)

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
        }
    }

	public func relyWithError(_ error: Error) async {
		let protocolError = AnyJSONRPCResponseError(code: JSONRPCErrors.internalError, message: "unsupported", data: nil)

		switch self {
		case let .workspaceConfiguration(_, handler):
			await handler(.failure(protocolError))
		case let .workspaceFolders(handler):
			await handler(.failure(protocolError))
		case let .workspaceApplyEdit(_, handler):
			await handler(.failure(protocolError))
		case let .clientRegisterCapability(_, handler):
			await handler(protocolError)
		case let .clientUnregisterCapability(_, handler):
			await handler(protocolError)
		case let .workspaceCodeLensRefresh(handler):
			await handler(protocolError)
		case let .workspaceSemanticTokenRefresh(handler):
			await handler(protocolError)
		case let .windowShowMessageRequest(_, handler):
			await handler(.failure(protocolError))
		case let .windowShowDocument(_, handler):
			await handler(.failure(protocolError))
		case let .windowWorkDoneProgressCreate(_, handler):
			await handler(protocolError)
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
