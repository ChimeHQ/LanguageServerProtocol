import Foundation
import LanguageServerProtocol

/// Handles the communication between an LSP client and server.
///
/// This protocol defines all the messages that can be sent between an LSP client and server. It does **not** enforce correct ordering of those messages.
public protocol ServerConnection {
	typealias EventSequence = AsyncStream<ServerEvent>

	var eventSequence: EventSequence { get }

	func sendNotification(_ notif: ClientNotification) async throws
	func sendRequest<Response: Decodable & Sendable>(_ request: ClientRequest) async throws -> Response
}

extension ServerConnection {
	func sendRequestWithErrorOnlyResult(_ request: ClientRequest) async throws {
		let _: UnusedResult = try await sendRequest(request)
	}
}

public extension ServerConnection {
	func initialize(params: InitializeParams) async throws -> InitializationResponse {
		return try await sendRequest(.initialize(params, ClientRequest.NullHandler))
	}

	func initialized(params: InitializedParams) async throws {
		try await sendNotification(.initialized(params))
	}

	func shutdown() async throws {
		try await sendRequestWithErrorOnlyResult(.shutdown(ClientRequest.NullHandler))
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

    func textDocumentDidOpen(params: DidOpenTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidOpen(params))
    }

    func textDocumentDidChange(params: DidChangeTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidChange(params))
    }

    func textDocumentDidClose(params: DidCloseTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidClose(params))
    }

    func textDocumentWillSave(params: WillSaveTextDocumentParams) async throws {
		try await sendNotification(.textDocumentWillSave(params))
    }

	func textDocumentWillSaveWaitUntil(params: WillSaveTextDocumentParams) async throws -> WillSaveWaitUntilResponse {
		try await sendRequest(.textDocumentWillSaveWaitUntil(params, ClientRequest.NullHandler))
	}

    func textDocumentDidSave(params: DidSaveTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidSave(params))
    }

    func workspaceDidChangeWatchedFiles(params: DidChangeWatchedFilesParams) async throws {
        try await sendNotification(.workspaceDidChangeWatchedFiles(params))
    }

	func callHierarchyIncomingCalls(params: CallHierarchyIncomingCallsParams) async throws -> CallHierarchyIncomingCallsResponse {
		try await sendRequest(.callHierarchyIncomingCalls(params, ClientRequest.NullHandler))
	}

	func callHierarchyOutgoingCalls(params: CallHierarchyOutgoingCallsParams) async throws -> CallHierarchyOutgoingCallsResponse {
		try await sendRequest(.callHierarchyOutgoingCalls(params, ClientRequest.NullHandler))
	}

    func completion(params: CompletionParams) async throws -> CompletionResponse {
        try await sendRequest(.completion(params, ClientRequest.NullHandler))
    }

    func hover(params: TextDocumentPositionParams) async throws -> HoverResponse {
        try await sendRequest(.hover(params, ClientRequest.NullHandler))
    }

    func signatureHelp(params: TextDocumentPositionParams) async throws -> SignatureHelpResponse {
        try await sendRequest(.signatureHelp(params, ClientRequest.NullHandler))
    }

    func declaration(params: TextDocumentPositionParams) async throws -> DeclarationResponse {
        try await sendRequest(.declaration(params, ClientRequest.NullHandler))
    }

    func definition(params: TextDocumentPositionParams) async throws -> DefinitionResponse {
        try await sendRequest(.definition(params, ClientRequest.NullHandler))
    }

    func typeDefinition(params: TextDocumentPositionParams) async throws -> TypeDefinitionResponse {
        try await sendRequest(.typeDefinition(params, ClientRequest.NullHandler))
    }

    func implementation(params: TextDocumentPositionParams) async throws -> ImplementationResponse {
        try await sendRequest(.implementation(params, ClientRequest.NullHandler))
    }

    func documentSymbol(params: DocumentSymbolParams) async throws -> DocumentSymbolResponse {
        try await sendRequest(.documentSymbol(params, ClientRequest.NullHandler))
    }

    func prepareCallHierarchy(params: CallHierarchyPrepareParams) async throws -> CallHierarchyPrepareResponse {
        try await sendRequest(.prepareCallHierarchy(params, ClientRequest.NullHandler))
    }

    func prepareRename(params: PrepareRenameParams) async throws -> PrepareRenameResponse {
        try await sendRequest(.prepareRename(params, ClientRequest.NullHandler))
    }

    func rename(params: RenameParams) async throws -> RenameResponse {
        try await sendRequest(.rename(params, ClientRequest.NullHandler))
    }

    func formatting(params: DocumentFormattingParams) async throws -> FormattingResult {
        try await sendRequest(.formatting(params, ClientRequest.NullHandler))
    }

    func rangeFormatting(params: DocumentRangeFormattingParams) async throws -> FormattingResult {
        try await sendRequest(.rangeFormatting(params, ClientRequest.NullHandler))
    }

    func onTypeFormatting(params: DocumentOnTypeFormattingParams) async throws -> FormattingResult {
        try await sendRequest(.onTypeFormatting(params, ClientRequest.NullHandler))
    }

    func references(params: ReferenceParams) async throws -> ReferenceResponse {
        try await sendRequest(.references(params, ClientRequest.NullHandler))
    }

    func foldingRange(params: FoldingRangeParams) async throws -> FoldingRangeResponse {
        try await sendRequest(.foldingRange(params, ClientRequest.NullHandler))
    }

    func semanticTokensFull(params: SemanticTokensParams) async throws -> SemanticTokensResponse {
        try await sendRequest(.semanticTokensFull(params, ClientRequest.NullHandler))
    }

    func semanticTokensFullDelta(params: SemanticTokensDeltaParams) async throws -> SemanticTokensDeltaResponse {
        try await sendRequest(.semanticTokensFullDelta(params, ClientRequest.NullHandler))
    }

    func semanticTokensRange(params: SemanticTokensRangeParams) async throws -> SemanticTokensResponse {
        try await sendRequest(.semanticTokensRange(params, ClientRequest.NullHandler))
    }


    func customRequest<Response: Decodable & Sendable>(method: String, params: LSPAny) async throws -> Response {
        try await sendRequest(.custom(method, params, ClientRequest.NullHandler))
    }
}

// Workspace notifications
public extension ServerConnection {
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
public extension ServerConnection {
	func inlayHintRefresh() async throws {
		try await sendRequestWithErrorOnlyResult(.workspaceInlayHintRefresh(ClientRequest.NullHandler))
	}

    func willCreateFiles(params: CreateFilesParams) async throws -> WorkspaceWillCreateFilesResponse {
        try await sendRequest(.workspaceWillCreateFiles(params, ClientRequest.NullHandler))
    }

    func willRenameFiles(params: RenameFilesParams) async throws -> WorkspaceWillRenameFilesResponse {
        try await sendRequest(.workspaceWillRenameFiles(params, ClientRequest.NullHandler))
    }

    func willDeleteFiles(params: DeleteFilesParams) async throws -> WorkspaceWillDeleteFilesResponse {
        try await sendRequest(.workspaceWillDeleteFiles(params, ClientRequest.NullHandler))
    }

    func executeCommand(params: ExecuteCommandParams) async throws -> ExecuteCommandResponse {
        try await sendRequest(.workspaceExecuteCommand(params, ClientRequest.NullHandler))
    }

    func workspaceSymbol(params: WorkspaceSymbolParams) async throws -> WorkspaceSymbolResponse {
        try await sendRequest(.workspaceSymbol(params, ClientRequest.NullHandler))
    }

    func workspaceSymbolResolve(params: WorkspaceSymbol) async throws -> WorkspaceSymbolResponse {
        try await sendRequest(.workspaceSymbolResolve(params, ClientRequest.NullHandler))
    }
}

// Language Features
public extension ServerConnection {
    func documentHighlight(params: DocumentHighlightParams) async throws -> DocumentHighlightResponse {
        try await sendRequest(.documentHighlight(params, ClientRequest.NullHandler))
    }

	func codeAction(params: CodeActionParams) async throws -> CodeActionResponse {
		try await sendRequest(.codeAction(params, ClientRequest.NullHandler))
	}

	func codeActionResolve(params: CodeAction) async throws -> CodeAction {
		try await sendRequest(.codeActionResolve(params, ClientRequest.NullHandler))
	}

    func codeLens(params: CodeLensParams) async throws -> CodeLensResponse {
        try await sendRequest(.codeLens(params, ClientRequest.NullHandler))
    }

    func codeLensResolve(params: CodeLens) async throws -> CodeLensResolveResponse {
        try await sendRequest(.codeLensResolve(params, ClientRequest.NullHandler))
    }

	func diagnostics(params: DocumentDiagnosticParams) async throws -> DocumentDiagnosticReport {
		try await sendRequest(.diagnostics(params, ClientRequest.NullHandler))
	}

    func selectionRange(params: SelectionRangeParams) async throws -> SelectionRangeResponse {
        try await sendRequest(.selectionRange(params, ClientRequest.NullHandler))
    }

    func documentLink(params: DocumentLinkParams) async throws -> DocumentLinkResponse {
        try await sendRequest(.documentLink(params, ClientRequest.NullHandler))
    }

    func documentLinkResolve(params: DocumentLink) async throws -> DocumentLink {
        try await sendRequest(.documentLinkResolve(params, ClientRequest.NullHandler))
    }

    func documentColor(params: DocumentColorParams) async throws -> DocumentColorResponse {
        try await sendRequest(.documentColor(params, ClientRequest.NullHandler))
    }

    func colorPresentation(params: ColorPresentationParams) async throws -> ColorPresentationResponse {
        try await sendRequest(.colorPresentation(params, ClientRequest.NullHandler))
    }

	func inlayHint(params: InlayHintParams) async throws -> InlayHintResponse {
		try await sendRequest(.inlayHint(params, ClientRequest.NullHandler))
	}

	func inlayHintResolve(params: InlayHint) async throws -> InlayHint {
		try await sendRequest(.inlayHintResolve(params, ClientRequest.NullHandler))
	}
}
