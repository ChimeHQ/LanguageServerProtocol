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
	func sendRequest<Response: Decodable & Sendable>(_ request: ClientRequest) async throws
		-> Response
}

extension Server {
	func sendRequestWithErrorOnlyResult(_ request: ClientRequest) async throws {
		let _: UnusedResult = try await sendRequest(request)
	}
}

extension Server {
	public func initialize(params: InitializeParams) async throws -> InitializationResponse {
		return try await sendRequest(.initialize(params))
	}

	public func initialized(params: InitializedParams) async throws {
		try await sendNotification(.initialized(params))
	}

	public func shutdown() async throws {
		try await sendRequestWithErrorOnlyResult(.shutdown)
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

	public func didOpenTextDocument(params: DidOpenTextDocumentParams) async throws {
		try await sendNotification(.didOpenTextDocument(params))
	}

	public func didChangeTextDocument(params: DidChangeTextDocumentParams) async throws {
		try await sendNotification(.didChangeTextDocument(params))
	}

	public func didCloseTextDocument(params: DidCloseTextDocumentParams) async throws {
		try await sendNotification(.didCloseTextDocument(params))
	}

	public func willSaveTextDocument(params: WillSaveTextDocumentParams) async throws {
		try await sendNotification(.willSaveTextDocument(params))
	}

	public func willSaveWaitUntilTextDocument(params: WillSaveTextDocumentParams) async throws
		-> WillSaveWaitUntilResponse
	{
		try await sendRequest(.willSaveWaitUntilTextDocument(params))
	}

	public func didSaveTextDocument(params: DidSaveTextDocumentParams) async throws {
		try await sendNotification(.didSaveTextDocument(params))
	}

	public func didChangeWatchedFiles(params: DidChangeWatchedFilesParams) async throws {
		try await sendNotification(.didChangeWatchedFiles(params))
	}

	public func callHierarchyIncomingCalls(params: CallHierarchyIncomingCallsParams) async throws
		-> CallHierarchyIncomingCallsResponse
	{
		try await sendRequest(.callHierarchyIncomingCalls(params))
	}

	public func callHierarchyOutgoingCalls(params: CallHierarchyOutgoingCallsParams) async throws
		-> CallHierarchyOutgoingCallsResponse
	{
		try await sendRequest(.callHierarchyOutgoingCalls(params))
	}

	public func completion(params: CompletionParams) async throws -> CompletionResponse {
		try await sendRequest(.completion(params))
	}

	public func hover(params: TextDocumentPositionParams) async throws -> HoverResponse {
		try await sendRequest(.hover(params))
	}

	public func signatureHelp(params: TextDocumentPositionParams) async throws
		-> SignatureHelpResponse
	{
		try await sendRequest(.signatureHelp(params))
	}

	public func declaration(params: TextDocumentPositionParams) async throws -> DeclarationResponse
	{
		try await sendRequest(.declaration(params))
	}

	public func definition(params: TextDocumentPositionParams) async throws -> DefinitionResponse {
		try await sendRequest(.definition(params))
	}

	public func typeDefinition(params: TextDocumentPositionParams) async throws
		-> TypeDefinitionResponse
	{
		try await sendRequest(.typeDefinition(params))
	}

	public func implementation(params: TextDocumentPositionParams) async throws
		-> ImplementationResponse
	{
		try await sendRequest(.implementation(params))
	}

	public func documentSymbol(params: DocumentSymbolParams) async throws -> DocumentSymbolResponse
	{
		try await sendRequest(.documentSymbol(params))
	}

	public func prepareCallHierarchy(params: CallHierarchyPrepareParams) async throws
		-> CallHierarchyPrepareResponse
	{
		try await sendRequest(.prepareCallHierarchy(params))
	}

	public func prepareRename(params: PrepareRenameParams) async throws -> PrepareRenameResponse {
		try await sendRequest(.prepareRename(params))
	}

	public func rename(params: RenameParams) async throws -> RenameResponse {
		try await sendRequest(.rename(params))
	}

	public func formatting(params: DocumentFormattingParams) async throws -> FormattingResult {
		try await sendRequest(.formatting(params))
	}

	public func rangeFormatting(params: DocumentRangeFormattingParams) async throws
		-> FormattingResult
	{
		try await sendRequest(.rangeFormatting(params))
	}

	public func onTypeFormatting(params: DocumentOnTypeFormattingParams) async throws
		-> FormattingResult
	{
		try await sendRequest(.onTypeFormatting(params))
	}

	public func references(params: ReferenceParams) async throws -> ReferenceResponse {
		try await sendRequest(.references(params))
	}

	public func foldingRange(params: FoldingRangeParams) async throws -> FoldingRangeResponse {
		try await sendRequest(.foldingRange(params))
	}

	public func semanticTokensFull(params: SemanticTokensParams) async throws
		-> SemanticTokensResponse
	{
		try await sendRequest(.semanticTokensFull(params))
	}

	public func semanticTokensFullDelta(params: SemanticTokensDeltaParams) async throws
		-> SemanticTokensDeltaResponse
	{
		try await sendRequest(.semanticTokensFullDelta(params))
	}

	public func semanticTokensRange(params: SemanticTokensRangeParams) async throws
		-> SemanticTokensResponse
	{
		try await sendRequest(.semanticTokensRange(params))
	}

	public func customRequest<Response: Decodable & Sendable>(method: String, params: LSPAny)
		async throws -> Response
	{
		try await sendRequest(.custom(method, params))
	}
}

// Workspace notifications
extension Server {
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
extension Server {
	public func willCreateFiles(params: CreateFilesParams) async throws
		-> WorkspaceWillCreateFilesResponse
	{
		try await sendRequest(.workspaceWillCreateFiles(params))
	}

	public func willRenameFiles(params: RenameFilesParams) async throws
		-> WorkspaceWillRenameFilesResponse
	{
		try await sendRequest(.workspaceWillRenameFiles(params))
	}

	public func willDeleteFiles(params: DeleteFilesParams) async throws
		-> WorkspaceWillDeleteFilesResponse
	{
		try await sendRequest(.workspaceWillDeleteFiles(params))
	}

	public func executeCommand(params: ExecuteCommandParams) async throws -> ExecuteCommandResponse
	{
		try await sendRequest(.workspaceExecuteCommand(params))
	}

	public func workspaceSymbol(params: WorkspaceSymbolParams) async throws
		-> WorkspaceSymbolResponse
	{
		try await sendRequest(.workspaceSymbol(params))
	}

	public func workspaceSymbolResolve(params: WorkspaceSymbol) async throws
		-> WorkspaceSymbolResponse
	{
		try await sendRequest(.workspaceSymbolResolve(params))
	}
}

// Language Features
extension Server {
	public func documentHighlight(params: DocumentHighlightParams) async throws
		-> DocumentHighlightResponse
	{
		try await sendRequest(.documentHighlight(params))
	}

	public func codeAction(params: CodeActionParams) async throws -> CodeActionResponse {
		try await sendRequest(.codeAction(params))
	}

	public func codeActionResolve(params: CodeAction) async throws -> CodeAction {
		try await sendRequest(.codeActionResolve(params))
	}

	public func codeLens(params: CodeLensParams) async throws -> CodeLensResponse {
		try await sendRequest(.codeLens(params))
	}

	public func codeLensResolve(params: CodeLens) async throws -> CodeLensResolveResponse {
		try await sendRequest(.codeLensResolve(params))
	}

	public func diagnostics(params: DocumentDiagnosticParams) async throws
		-> DocumentDiagnosticReport
	{
		try await sendRequest(.diagnostics(params))
	}

	public func selectionRange(params: SelectionRangeParams) async throws -> SelectionRangeResponse
	{
		try await sendRequest(.selectionRange(params))
	}

	public func documentLink(params: DocumentLinkParams) async throws -> DocumentLinkResponse {
		try await sendRequest(.documentLink(params))
	}

	public func documentLinkResolve(params: DocumentLink) async throws -> DocumentLink {
		try await sendRequest(.documentLinkResolve(params))
	}

	public func documentColor(params: DocumentColorParams) async throws -> DocumentColorResponse {
		try await sendRequest(.documentColor(params))
	}

	public func colorPresentation(params: ColorPresentationParams) async throws
		-> ColorPresentationResponse
	{
		try await sendRequest(.colorPresentation(params))
	}
}
