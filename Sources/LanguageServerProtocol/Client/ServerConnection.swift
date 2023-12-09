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
	public func initialize(params: InitializeParams) async throws -> InitializationResponse {
		return try await sendRequest(.initialize(params, ClientRequest.NullHandler))
	}

	public func initialized(params: InitializedParams) async throws {
		try await sendNotification(.initialized(params))
	}

	public func shutdown() async throws {
		try await sendRequestWithErrorOnlyResult(.shutdown(ClientRequest.NullHandler))
	}

	public func exit() async throws {
		try await sendNotification(.exit)
	}

	public func cancelRequest(params: CancelParams) async throws {
		try await sendNotification(.protocolCancelRequest(params))
	}

	public func setTrace(params: SetTraceParams) async throws {
		try await sendNotification(.protocolSetTrace(params))
	}

	public func textDocumentDidOpen(params: DidOpenTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidOpen(params))
	}

	@available(
		*, deprecated, renamed: "textDocumentDidOpen",
		message: "This method has been renamed to better match the spec."
	)
	public func didOpenTextDocument(params: DidOpenTextDocumentParams) async throws {
		try await textDocumentDidOpen(params: params)
	}

	public func textDocumentDidChange(params: DidChangeTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidChange(params))
	}

	@available(
		*, deprecated, renamed: "textDocumentDidChange",
		message: "This method has been renamed to better match the spec."
	)
	public func didChangeTextDocument(params: DidChangeTextDocumentParams) async throws {
		try await textDocumentDidChange(params: params)
	}

	public func textDocumentDidClose(params: DidCloseTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidClose(params))
	}

	@available(
		*, deprecated, renamed: "didCloseTextDocument",
		message: "This method has been renamed to better match the spec."
	)
	public func didCloseTextDocument(params: DidCloseTextDocumentParams) async throws {
		try await textDocumentDidClose(params: params)
	}

	public func textDocumentWillSave(params: WillSaveTextDocumentParams) async throws {
		try await sendNotification(.textDocumentWillSave(params))
	}

	@available(
		*, deprecated, renamed: "textDocumentWillSave",
		message: "This method has been renamed to better match the spec."
	)
	public func willSaveTextDocument(params: WillSaveTextDocumentParams) async throws {
		try await textDocumentWillSave(params: params)
	}

	public func textDocumentWillSaveWaitUntil(params: WillSaveTextDocumentParams) async throws
		-> WillSaveWaitUntilResponse
	{
		try await sendRequest(.textDocumentWillSaveWaitUntil(params, ClientRequest.NullHandler))
	}

	public func textDocumentDidSave(params: DidSaveTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidSave(params))
	}

	public func workspaceDidChangeWatchedFiles(params: DidChangeWatchedFilesParams) async throws {
		try await sendNotification(.workspaceDidChangeWatchedFiles(params))
	}

	@available(
		*, deprecated, renamed: "workspaceDidChangeWatchedFiles",
		message: "This method has been renamed to better match the spec."
	)
	public func didChangeWatchedFiles(params: DidChangeWatchedFilesParams) async throws {
		try await workspaceDidChangeWatchedFiles(params: params)
	}

	public func callHierarchyIncomingCalls(params: CallHierarchyIncomingCallsParams) async throws
		-> CallHierarchyIncomingCallsResponse
	{
		try await sendRequest(.callHierarchyIncomingCalls(params, ClientRequest.NullHandler))
	}

	public func callHierarchyOutgoingCalls(params: CallHierarchyOutgoingCallsParams) async throws
		-> CallHierarchyOutgoingCallsResponse
	{
		try await sendRequest(.callHierarchyOutgoingCalls(params, ClientRequest.NullHandler))
	}

	public func completion(params: CompletionParams) async throws -> CompletionResponse {
		try await sendRequest(.completion(params, ClientRequest.NullHandler))
	}

	public func hover(params: TextDocumentPositionParams) async throws -> HoverResponse {
		try await sendRequest(.hover(params, ClientRequest.NullHandler))
	}

	public func signatureHelp(params: TextDocumentPositionParams) async throws
		-> SignatureHelpResponse
	{
		try await sendRequest(.signatureHelp(params, ClientRequest.NullHandler))
	}

	public func declaration(params: TextDocumentPositionParams) async throws -> DeclarationResponse
	{
		try await sendRequest(.declaration(params, ClientRequest.NullHandler))
	}

	public func definition(params: TextDocumentPositionParams) async throws -> DefinitionResponse {
		try await sendRequest(.definition(params, ClientRequest.NullHandler))
	}

	public func typeDefinition(params: TextDocumentPositionParams) async throws
		-> TypeDefinitionResponse
	{
		try await sendRequest(.typeDefinition(params, ClientRequest.NullHandler))
	}

	public func implementation(params: TextDocumentPositionParams) async throws
		-> ImplementationResponse
	{
		try await sendRequest(.implementation(params, ClientRequest.NullHandler))
	}

	public func documentSymbol(params: DocumentSymbolParams) async throws -> DocumentSymbolResponse
	{
		try await sendRequest(.documentSymbol(params, ClientRequest.NullHandler))
	}

	public func prepareCallHierarchy(params: CallHierarchyPrepareParams) async throws
		-> CallHierarchyPrepareResponse
	{
		try await sendRequest(.prepareCallHierarchy(params, ClientRequest.NullHandler))
	}

	public func prepareRename(params: PrepareRenameParams) async throws -> PrepareRenameResponse {
		try await sendRequest(.prepareRename(params, ClientRequest.NullHandler))
	}

	public func prepareTypeHeirarchy(params: TypeHierarchyPrepareParams) async throws
		-> PrepareTypeHeirarchyResponse
	{
		try await sendRequest(.prepareTypeHierarchy(params, ClientRequest.NullHandler))
	}

	public func rename(params: RenameParams) async throws -> RenameResponse {
		try await sendRequest(.rename(params, ClientRequest.NullHandler))
	}

	public func formatting(params: DocumentFormattingParams) async throws -> FormattingResult {
		try await sendRequest(.formatting(params, ClientRequest.NullHandler))
	}

	public func rangeFormatting(params: DocumentRangeFormattingParams) async throws
		-> FormattingResult
	{
		try await sendRequest(.rangeFormatting(params, ClientRequest.NullHandler))
	}

	public func onTypeFormatting(params: DocumentOnTypeFormattingParams) async throws
		-> FormattingResult
	{
		try await sendRequest(.onTypeFormatting(params, ClientRequest.NullHandler))
	}

	public func references(params: ReferenceParams) async throws -> ReferenceResponse {
		try await sendRequest(.references(params, ClientRequest.NullHandler))
	}

	public func foldingRange(params: FoldingRangeParams) async throws -> FoldingRangeResponse {
		try await sendRequest(.foldingRange(params, ClientRequest.NullHandler))
	}

	public func semanticTokensFull(params: SemanticTokensParams) async throws
		-> SemanticTokensResponse
	{
		try await sendRequest(.semanticTokensFull(params, ClientRequest.NullHandler))
	}

	public func semanticTokensFullDelta(params: SemanticTokensDeltaParams) async throws
		-> SemanticTokensDeltaResponse
	{
		try await sendRequest(.semanticTokensFullDelta(params, ClientRequest.NullHandler))
	}

	public func semanticTokensRange(params: SemanticTokensRangeParams) async throws
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
	public func didChangeWorkspaceFolders(params: DidChangeWorkspaceFoldersParams) async throws {
		try await sendNotification(.workspaceDidChangeWorkspaceFolders(params))
	}

	public func didChangeConfiguration(params: DidChangeConfigurationParams) async throws {
		try await sendNotification(.workspaceDidChangeConfiguration(params))
	}

	public func didCreateFiles(params: CreateFilesParams) async throws {
		try await sendNotification(.workspaceDidCreateFiles(params))
	}

	public func didRenameFiles(params: RenameFilesParams) async throws {
		try await sendNotification(.workspaceDidRenameFiles(params))
	}

	public func didDeleteFiles(params: DeleteFilesParams) async throws {
		try await sendNotification(.workspaceDidDeleteFiles(params))
	}
}

// Workspace Requests
extension ServerConnection {
	public func inlayHintRefresh() async throws {
		try await sendRequestWithErrorOnlyResult(
			.workspaceInlayHintRefresh(ClientRequest.NullHandler))
	}

	public func willCreateFiles(params: CreateFilesParams) async throws
		-> WorkspaceWillCreateFilesResponse
	{
		try await sendRequest(.workspaceWillCreateFiles(params, ClientRequest.NullHandler))
	}

	public func willRenameFiles(params: RenameFilesParams) async throws
		-> WorkspaceWillRenameFilesResponse
	{
		try await sendRequest(.workspaceWillRenameFiles(params, ClientRequest.NullHandler))
	}

	public func willDeleteFiles(params: DeleteFilesParams) async throws
		-> WorkspaceWillDeleteFilesResponse
	{
		try await sendRequest(.workspaceWillDeleteFiles(params, ClientRequest.NullHandler))
	}

	public func executeCommand(params: ExecuteCommandParams) async throws -> ExecuteCommandResponse
	{
		try await sendRequest(.workspaceExecuteCommand(params, ClientRequest.NullHandler))
	}

	public func workspaceSymbol(params: WorkspaceSymbolParams) async throws
		-> WorkspaceSymbolResponse
	{
		try await sendRequest(.workspaceSymbol(params, ClientRequest.NullHandler))
	}

	public func workspaceSymbolResolve(params: WorkspaceSymbol) async throws
		-> WorkspaceSymbolResponse
	{
		try await sendRequest(.workspaceSymbolResolve(params, ClientRequest.NullHandler))
	}
}

// Language Features
extension ServerConnection {
	public func documentHighlight(params: DocumentHighlightParams) async throws
		-> DocumentHighlightResponse
	{
		try await sendRequest(.documentHighlight(params, ClientRequest.NullHandler))
	}

	public func codeAction(params: CodeActionParams) async throws -> CodeActionResponse {
		try await sendRequest(.codeAction(params, ClientRequest.NullHandler))
	}

	public func codeActionResolve(params: CodeAction) async throws -> CodeAction {
		try await sendRequest(.codeActionResolve(params, ClientRequest.NullHandler))
	}

	public func codeLens(params: CodeLensParams) async throws -> CodeLensResponse {
		try await sendRequest(.codeLens(params, ClientRequest.NullHandler))
	}

	public func codeLensResolve(params: CodeLens) async throws -> CodeLensResolveResponse {
		try await sendRequest(.codeLensResolve(params, ClientRequest.NullHandler))
	}

	public func diagnostics(params: DocumentDiagnosticParams) async throws
		-> DocumentDiagnosticReport
	{
		try await sendRequest(.diagnostics(params, ClientRequest.NullHandler))
	}

	public func selectionRange(params: SelectionRangeParams) async throws -> SelectionRangeResponse
	{
		try await sendRequest(.selectionRange(params, ClientRequest.NullHandler))
	}

	public func documentLink(params: DocumentLinkParams) async throws -> DocumentLinkResponse {
		try await sendRequest(.documentLink(params, ClientRequest.NullHandler))
	}

	public func documentLinkResolve(params: DocumentLink) async throws -> DocumentLink {
		try await sendRequest(.documentLinkResolve(params, ClientRequest.NullHandler))
	}

	public func documentColor(params: DocumentColorParams) async throws -> DocumentColorResponse {
		try await sendRequest(.documentColor(params, ClientRequest.NullHandler))
	}

	public func colorPresentation(params: ColorPresentationParams) async throws
		-> ColorPresentationResponse
	{
		try await sendRequest(.colorPresentation(params, ClientRequest.NullHandler))
	}

	public func inlayHint(params: InlayHintParams) async throws -> InlayHintResponse {
		try await sendRequest(.inlayHint(params, ClientRequest.NullHandler))
	}

	public func inlayHintResolve(params: InlayHint) async throws -> InlayHint {
		try await sendRequest(.inlayHintResolve(params, ClientRequest.NullHandler))
	}
}
