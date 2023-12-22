import Foundation

/// Handles the communication between an LSP client and server.
///
/// This protocol defines all the messages that can be sent between an LSP client and server. It does **not** enforce correct ordering of those messages.
public protocol ServerConnection {
	typealias EventSequence = AsyncStream<ServerEvent>

	var eventSequence: EventSequence { get }

	func sendNotification(_ notif: ClientNotification) async throws
	func sendRequest<Response: Decodable & Sendable>(_ request: ClientRequest) async throws
		-> Response
}

extension ServerConnection {
	func sendRequestWithErrorOnlyResult(_ request: ClientRequest) async throws {
		let _: UnusedResult = try await sendRequest(request)
	}
}

extension ServerConnection {
	public func initialize(_ params: InitializeParams) async throws -> InitializationResponse {
		return try await sendRequest(.initialize(params, ClientRequest.NullHandler))
	}

	public func initialized(_ params: InitializedParams) async throws {
		try await sendNotification(.initialized(params))
	}

	public func shutdown() async throws {
		try await sendRequestWithErrorOnlyResult(.shutdown(ClientRequest.NullHandler))
	}

	public func exit() async throws {
		try await sendNotification(.exit)
	}

	public func cancelRequest(_ params: CancelParams) async throws {
		try await sendNotification(.protocolCancelRequest(params))
	}

	public func setTrace(_ params: SetTraceParams) async throws {
		try await sendNotification(.protocolSetTrace(params))
	}

	public func textDocumentDidOpen(_ params: DidOpenTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidOpen(params))
	}

	@available(
		*, deprecated, renamed: "textDocumentDidOpen",
		message: "This method has been renamed to better match the spec."
	)
	public func didOpenTextDocument(_ params: DidOpenTextDocumentParams) async throws {
		try await textDocumentDidOpen(params)
	}

	public func textDocumentDidChange(_ params: DidChangeTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidChange(params))
	}

	@available(
		*, deprecated, renamed: "textDocumentDidChange",
		message: "This method has been renamed to better match the spec."
	)
	public func didChangeTextDocument(_ params: DidChangeTextDocumentParams) async throws {
		try await textDocumentDidChange(params)
	}

	public func textDocumentDidClose(_ params: DidCloseTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidClose(params))
	}

	@available(
		*, deprecated, renamed: "didCloseTextDocument",
		message: "This method has been renamed to better match the spec."
	)
	public func didCloseTextDocument(_ params: DidCloseTextDocumentParams) async throws {
		try await textDocumentDidClose(params)
	}

	public func textDocumentWillSave(_ params: WillSaveTextDocumentParams) async throws {
		try await sendNotification(.textDocumentWillSave(params))
	}

	@available(
		*, deprecated, renamed: "textDocumentWillSave",
		message: "This method has been renamed to better match the spec."
	)
	public func willSaveTextDocument(_ params: WillSaveTextDocumentParams) async throws {
		try await textDocumentWillSave(params)
	}

	public func textDocumentWillSaveWaitUntil(_ params: WillSaveTextDocumentParams) async throws
		-> WillSaveWaitUntilResponse
	{
		try await sendRequest(.textDocumentWillSaveWaitUntil(params, ClientRequest.NullHandler))
	}

	public func textDocumentDidSave(_ params: DidSaveTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidSave(params))
	}

	public func workspaceDidChangeWatchedFiles(_ params: DidChangeWatchedFilesParams) async throws {
		try await sendNotification(.workspaceDidChangeWatchedFiles(params))
	}

	@available(
		*, deprecated, renamed: "workspaceDidChangeWatchedFiles",
		message: "This method has been renamed to better match the spec."
	)
	public func didChangeWatchedFiles(_ params: DidChangeWatchedFilesParams) async throws {
		try await workspaceDidChangeWatchedFiles(params)
	}

	public func callHierarchyIncomingCalls(_ params: CallHierarchyIncomingCallsParams) async throws
		-> CallHierarchyIncomingCallsResponse
	{
		try await sendRequest(.callHierarchyIncomingCalls(params, ClientRequest.NullHandler))
	}

	public func callHierarchyOutgoingCalls(_ params: CallHierarchyOutgoingCallsParams) async throws
		-> CallHierarchyOutgoingCallsResponse
	{
		try await sendRequest(.callHierarchyOutgoingCalls(params, ClientRequest.NullHandler))
	}

	public func completion(_ params: CompletionParams) async throws -> CompletionResponse {
		try await sendRequest(.completion(params, ClientRequest.NullHandler))
	}

	public func hover(_ params: TextDocumentPositionParams) async throws -> HoverResponse {
		try await sendRequest(.hover(params, ClientRequest.NullHandler))
	}

	public func signatureHelp(_ params: TextDocumentPositionParams) async throws
		-> SignatureHelpResponse
	{
		try await sendRequest(.signatureHelp(params, ClientRequest.NullHandler))
	}

	public func declaration(_ params: TextDocumentPositionParams) async throws -> DeclarationResponse
	{
		try await sendRequest(.declaration(params, ClientRequest.NullHandler))
	}

	public func definition(_ params: TextDocumentPositionParams) async throws -> DefinitionResponse {
		try await sendRequest(.definition(params, ClientRequest.NullHandler))
	}

	public func typeDefinition(_ params: TextDocumentPositionParams) async throws
		-> TypeDefinitionResponse
	{
		try await sendRequest(.typeDefinition(params, ClientRequest.NullHandler))
	}

	public func implementation(_ params: TextDocumentPositionParams) async throws
		-> ImplementationResponse
	{
		try await sendRequest(.implementation(params, ClientRequest.NullHandler))
	}

	public func documentSymbol(_ params: DocumentSymbolParams) async throws -> DocumentSymbolResponse
	{
		try await sendRequest(.documentSymbol(params, ClientRequest.NullHandler))
	}

	public func prepareCallHierarchy(_ params: CallHierarchyPrepareParams) async throws
		-> CallHierarchyPrepareResponse
	{
		try await sendRequest(.prepareCallHierarchy(params, ClientRequest.NullHandler))
	}

	public func prepareRename(_ params: PrepareRenameParams) async throws -> PrepareRenameResponse {
		try await sendRequest(.prepareRename(params, ClientRequest.NullHandler))
	}

	public func prepareTypeHeirarchy(_ params: TypeHierarchyPrepareParams) async throws
		-> PrepareTypeHeirarchyResponse
	{
		try await sendRequest(.prepareTypeHierarchy(params, ClientRequest.NullHandler))
	}

	public func rename(_ params: RenameParams) async throws -> RenameResponse {
		try await sendRequest(.rename(params, ClientRequest.NullHandler))
	}

	public func formatting(_ params: DocumentFormattingParams) async throws -> FormattingResult {
		try await sendRequest(.formatting(params, ClientRequest.NullHandler))
	}

	public func rangeFormatting(_ params: DocumentRangeFormattingParams) async throws
		-> FormattingResult
	{
		try await sendRequest(.rangeFormatting(params, ClientRequest.NullHandler))
	}

	public func onTypeFormatting(_ params: DocumentOnTypeFormattingParams) async throws
		-> FormattingResult
	{
		try await sendRequest(.onTypeFormatting(params, ClientRequest.NullHandler))
	}

	public func references(_ params: ReferenceParams) async throws -> ReferenceResponse {
		try await sendRequest(.references(params, ClientRequest.NullHandler))
	}

	public func foldingRange(_ params: FoldingRangeParams) async throws -> FoldingRangeResponse {
		try await sendRequest(.foldingRange(params, ClientRequest.NullHandler))
	}

	public func semanticTokensFull(_ params: SemanticTokensParams) async throws
		-> SemanticTokensResponse
	{
		try await sendRequest(.semanticTokensFull(params, ClientRequest.NullHandler))
	}

	public func semanticTokensFullDelta(_ params: SemanticTokensDeltaParams) async throws
		-> SemanticTokensDeltaResponse
	{
		try await sendRequest(.semanticTokensFullDelta(params, ClientRequest.NullHandler))
	}

	public func semanticTokensRange(_ params: SemanticTokensRangeParams) async throws
		-> SemanticTokensResponse
	{
		try await sendRequest(.semanticTokensRange(params, ClientRequest.NullHandler))
	}

	public func customRequest<Response: Decodable & Sendable>(method: String, params: LSPAny)
		async throws -> Response
	{
		try await sendRequest(.custom(method, params, ClientRequest.NullHandler))
	}
}

// Workspace notifications
extension ServerConnection {
	public func didChangeWorkspaceFolders(_ params: DidChangeWorkspaceFoldersParams) async throws {
		try await sendNotification(.workspaceDidChangeWorkspaceFolders(params))
	}

	public func didChangeConfiguration(_ params: DidChangeConfigurationParams) async throws {
		try await sendNotification(.workspaceDidChangeConfiguration(params))
	}

	public func didCreateFiles(_ params: CreateFilesParams) async throws {
		try await sendNotification(.workspaceDidCreateFiles(params))
	}

	public func didRenameFiles(_ params: RenameFilesParams) async throws {
		try await sendNotification(.workspaceDidRenameFiles(params))
	}

	public func didDeleteFiles(_ params: DeleteFilesParams) async throws {
		try await sendNotification(.workspaceDidDeleteFiles(params))
	}
}

// Workspace Requests
extension ServerConnection {
	public func inlayHintRefresh() async throws {
		try await sendRequestWithErrorOnlyResult(
			.workspaceInlayHintRefresh(ClientRequest.NullHandler))
	}

	public func willCreateFiles(_ params: CreateFilesParams) async throws
		-> WorkspaceWillCreateFilesResponse
	{
		try await sendRequest(.workspaceWillCreateFiles(params, ClientRequest.NullHandler))
	}

	public func willRenameFiles(_ params: RenameFilesParams) async throws
		-> WorkspaceWillRenameFilesResponse
	{
		try await sendRequest(.workspaceWillRenameFiles(params, ClientRequest.NullHandler))
	}

	public func willDeleteFiles(_ params: DeleteFilesParams) async throws
		-> WorkspaceWillDeleteFilesResponse
	{
		try await sendRequest(.workspaceWillDeleteFiles(params, ClientRequest.NullHandler))
	}

	public func executeCommand(_ params: ExecuteCommandParams) async throws -> ExecuteCommandResponse
	{
		try await sendRequest(.workspaceExecuteCommand(params, ClientRequest.NullHandler))
	}

	public func workspaceSymbol(_ params: WorkspaceSymbolParams) async throws
		-> WorkspaceSymbolResponse
	{
		try await sendRequest(.workspaceSymbol(params, ClientRequest.NullHandler))
	}

	public func workspaceSymbolResolve(_ params: WorkspaceSymbol) async throws
		-> WorkspaceSymbolResponse
	{
		try await sendRequest(.workspaceSymbolResolve(params, ClientRequest.NullHandler))
	}
}

// Language Features
extension ServerConnection {
	public func documentHighlight(_ params: DocumentHighlightParams) async throws
		-> DocumentHighlightResponse
	{
		try await sendRequest(.documentHighlight(params, ClientRequest.NullHandler))
	}

	public func codeAction(_ params: CodeActionParams) async throws -> CodeActionResponse {
		try await sendRequest(.codeAction(params, ClientRequest.NullHandler))
	}

	public func codeActionResolve(_ params: CodeAction) async throws -> CodeAction {
		try await sendRequest(.codeActionResolve(params, ClientRequest.NullHandler))
	}

	public func codeLens(_ params: CodeLensParams) async throws -> CodeLensResponse {
		try await sendRequest(.codeLens(params, ClientRequest.NullHandler))
	}

	public func codeLensResolve(_ params: CodeLens) async throws -> CodeLensResolveResponse {
		try await sendRequest(.codeLensResolve(params, ClientRequest.NullHandler))
	}

	public func diagnostics(_ params: DocumentDiagnosticParams) async throws
		-> DocumentDiagnosticReport
	{
		try await sendRequest(.diagnostics(params, ClientRequest.NullHandler))
	}

	public func selectionRange(_ params: SelectionRangeParams) async throws -> SelectionRangeResponse
	{
		try await sendRequest(.selectionRange(params, ClientRequest.NullHandler))
	}

	public func documentLink(_ params: DocumentLinkParams) async throws -> DocumentLinkResponse {
		try await sendRequest(.documentLink(params, ClientRequest.NullHandler))
	}

	public func documentLinkResolve(_ params: DocumentLink) async throws -> DocumentLink {
		try await sendRequest(.documentLinkResolve(params, ClientRequest.NullHandler))
	}

	public func documentColor(_ params: DocumentColorParams) async throws -> DocumentColorResponse {
		try await sendRequest(.documentColor(params, ClientRequest.NullHandler))
	}

	public func colorPresentation(_ params: ColorPresentationParams) async throws
		-> ColorPresentationResponse
	{
		try await sendRequest(.colorPresentation(params, ClientRequest.NullHandler))
	}

	public func inlayHint(_ params: InlayHintParams) async throws -> InlayHintResponse {
		try await sendRequest(.inlayHint(params, ClientRequest.NullHandler))
	}

	public func inlayHintResolve(_ params: InlayHint) async throws -> InlayHint {
		try await sendRequest(.inlayHintResolve(params, ClientRequest.NullHandler))
	}
}
