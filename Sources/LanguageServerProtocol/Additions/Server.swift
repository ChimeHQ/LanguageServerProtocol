import Foundation

/// Handles the communication between an LSP client and server.
///
/// This protocol defines all the messages that can be sent between an LSP client and server. It does **not** enforce correct ordering of those messages.
public protocol Server {
	typealias NotificationSequence = AsyncStream<ServerNotification>
	typealias RequestSequence = AsyncStream<ServerRequest>

	var notificationSequence: NotificationSequence { get }
	var requestSequence: RequestSequence { get }

	func sendNotification(_ notif: ClientNotification) async throws
	func sendRequest<Response: Decodable & Sendable>(_ request: ClientRequest) async throws -> Response
}

extension Server {
	func sendRequestWithErrorOnlyResult(_ request: ClientRequest) async throws {
		let _: UnusedResult = try await sendRequest(request)
	}
}

public extension Server {
	func initialize(params: InitializeParams) async throws -> InitializationResponse {
		return try await sendRequest(.initialize(params))
	}

	func initialized(params: InitializedParams) async throws {
		try await sendNotification(.initialized(params))
	}

	func shutdown() async throws {
		try await sendRequestWithErrorOnlyResult(.shutdown)
	}

	func exit() async throws {
		try await sendNotification(.exit)
	}

    func cancelRequest(params: CancelParams) async throws {
        try await sendNotification(.protocolCancelRequest(params))
    }

    func setTrace(params: SetTraceParams) async throws {
        try await sendNotification(.protocolSetTrace(params))
    }

    func didOpenTextDocument(params: DidOpenTextDocumentParams) async throws {
		try await sendNotification(.didOpenTextDocument(params))
    }

    func didChangeTextDocument(params: DidChangeTextDocumentParams) async throws {
		try await sendNotification(.didChangeTextDocument(params))
    }

    func didCloseTextDocument(params: DidCloseTextDocumentParams) async throws {
		try await sendNotification(.didCloseTextDocument(params))
    }

    func willSaveTextDocument(params: WillSaveTextDocumentParams) async throws {
		try await sendNotification(.willSaveTextDocument(params))
    }

	func willSaveWaitUntilTextDocument(params: WillSaveTextDocumentParams) async throws -> WillSaveWaitUntilResponse {
		try await sendRequest(.willSaveWaitUntilTextDocument(params))
	}

    func didSaveTextDocument(params: DidSaveTextDocumentParams) async throws {
		try await sendNotification(.didSaveTextDocument(params))
    }

    func didChangeWatchedFiles(params: DidChangeWatchedFilesParams) async throws {
        try await sendNotification(.didChangeWatchedFiles(params))
    }

	func callHierarchyIncomingCalls(params: CallHierarchyIncomingCallsParams) async throws -> CallHierarchyIncomingCallsResponse {
		try await sendRequest(.callHierarchyIncomingCalls(params))
	}

	func callHierarchyOutgoingCalls(params: CallHierarchyOutgoingCallsParams) async throws -> CallHierarchyOutgoingCallsResponse {
		try await sendRequest(.callHierarchyOutgoingCalls(params))
	}

    func completion(params: CompletionParams) async throws -> CompletionResponse {
        try await sendRequest(.completion(params))
    }

    func hover(params: TextDocumentPositionParams) async throws -> HoverResponse {
        try await sendRequest(.hover(params))
    }

    func signatureHelp(params: TextDocumentPositionParams) async throws -> SignatureHelpResponse {
        try await sendRequest(.signatureHelp(params))
    }

    func declaration(params: TextDocumentPositionParams) async throws -> DeclarationResponse {
        try await sendRequest(.declaration(params))
    }

    func definition(params: TextDocumentPositionParams) async throws -> DefinitionResponse {
        try await sendRequest(.definition(params))
    }

    func typeDefinition(params: TextDocumentPositionParams) async throws -> TypeDefinitionResponse {
        try await sendRequest(.typeDefinition(params))
    }

    func implementation(params: TextDocumentPositionParams) async throws -> ImplementationResponse {
        try await sendRequest(.implementation(params))
    }

    func documentSymbol(params: DocumentSymbolParams) async throws -> DocumentSymbolResponse {
        try await sendRequest(.documentSymbol(params))
    }

    func prepareCallHierarchy(params: CallHierarchyPrepareParams) async throws -> CallHierarchyPrepareResponse {
        try await sendRequest(.prepareCallHierarchy(params))
    }

    func prepareRename(params: PrepareRenameParams) async throws -> PrepareRenameResponse {
        try await sendRequest(.prepareRename(params))
    }

    func rename(params: RenameParams) async throws -> RenameResponse {
        try await sendRequest(.rename(params))
    }

    func formatting(params: DocumentFormattingParams) async throws -> FormattingResult {
        try await sendRequest(.formatting(params))
    }

    func rangeFormatting(params: DocumentRangeFormattingParams) async throws -> FormattingResult {
        try await sendRequest(.rangeFormatting(params))
    }

    func onTypeFormatting(params: DocumentOnTypeFormattingParams) async throws -> FormattingResult {
        try await sendRequest(.onTypeFormatting(params))
    }

    func references(params: ReferenceParams) async throws -> ReferenceResponse {
        try await sendRequest(.references(params))
    }

    func foldingRange(params: FoldingRangeParams) async throws -> FoldingRangeResponse {
        try await sendRequest(.foldingRange(params))
    }

    func semanticTokensFull(params: SemanticTokensParams) async throws -> SemanticTokensResponse {
        try await sendRequest(.semanticTokensFull(params))
    }

    func semanticTokensFullDelta(params: SemanticTokensDeltaParams) async throws -> SemanticTokensDeltaResponse {
        try await sendRequest(.semanticTokensFullDelta(params))
    }

    func semanticTokensRange(params: SemanticTokensRangeParams) async throws -> SemanticTokensResponse {
        try await sendRequest(.semanticTokensRange(params))
    }


    func customRequest<Response: Decodable & Sendable>(method: String, params: LSPAny) async throws -> Response {
        try await sendRequest(.custom(method, params))
    }
}

// Workspace notifications
public extension Server {
    func didChangeWorkspaceFolders(params: DidChangeWorkspaceFoldersParams) async throws {
        try await sendNotification(.workspaceDidChangeWorkspaceFolders(params))
    }

    func didChangeConfiguration(params: DidChangeConfigurationParams) async throws {
		try await sendNotification(.workspaceDidChangeConfiguration(params))
    }

    func didCreateFiles(params: CreateFilesParams) async throws {
		try await sendNotification(.workspaceDidCreateFiles(params))
    }

    func didRenameFiles(params: RenameFilesParams) async throws {
		try await sendNotification(.workspaceDidRenameFiles(params))
    }

    func didDeleteFiles(params: DeleteFilesParams) async throws {
		try await sendNotification(.workspaceDidDeleteFiles(params))
    }
}

// Workspace Requests
public extension Server {
    func willCreateFiles(params: CreateFilesParams) async throws -> WorkspaceWillCreateFilesResponse {
        try await sendRequest(.workspaceWillCreateFiles(params))
    }

    func willRenameFiles(params: RenameFilesParams) async throws -> WorkspaceWillRenameFilesResponse {
        try await sendRequest(.workspaceWillRenameFiles(params))
    }

    func willDeleteFiles(params: DeleteFilesParams) async throws -> WorkspaceWillDeleteFilesResponse {
        try await sendRequest(.workspaceWillDeleteFiles(params))
    }

    func executeCommand(params: ExecuteCommandParams) async throws -> ExecuteCommandResponse {
        try await sendRequest(.workspaceExecuteCommand(params))
    }

    func workspaceSymbol(params: WorkspaceSymbolParams) async throws -> WorkspaceSymbolResponse {
        try await sendRequest(.workspaceSymbol(params))
    }

    func workspaceSymbolResolve(params: WorkspaceSymbol) async throws -> WorkspaceSymbolResponse {
        try await sendRequest(.workspaceSymbolResolve(params))
    }
}

// Language Features
public extension Server {
    func documentHighlight(params: DocumentHighlightParams) async throws -> DocumentHighlightResponse {
        try await sendRequest(.documentHighlight(params))
    }

	func codeAction(params: CodeActionParams) async throws -> CodeActionResponse {
		try await sendRequest(.codeAction(params))
	}

	func codeActionResolve(params: CodeAction) async throws -> CodeAction {
		try await sendRequest(.codeActionResolve(params))
	}

    func codeLens(params: CodeLensParams) async throws -> CodeLensResponse {
        try await sendRequest(.codeLens(params))
    }

    func codeLensResolve(params: CodeLens) async throws -> CodeLensResolveResponse {
        try await sendRequest(.codeLensResolve(params))
    }

	func diagnostics(params: DocumentDiagnosticParams) async throws -> DocumentDiagnosticReport {
		try await sendRequest(.diagnostics(params))
	}
	
    func selectionRange(params: SelectionRangeParams) async throws -> SelectionRangeResponse {
        try await sendRequest(.selectionRange(params))
    }

    func documentLink(params: DocumentLinkParams) async throws -> DocumentLinkResponse {
        try await sendRequest(.documentLink(params))
    }

    func documentLinkResolve(params: DocumentLink) async throws -> DocumentLink {
        try await sendRequest(.documentLinkResolve(params))
    }

    func documentColor(params: DocumentColorParams) async throws -> DocumentColorResponse {
        try await sendRequest(.documentColor(params))
    }

    func colorPresentation(params: ColorPresentationParams) async throws -> ColorPresentationResponse {
        try await sendRequest(.colorPresentation(params))
    }
}
