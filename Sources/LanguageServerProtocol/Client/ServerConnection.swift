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
	@available(*, deprecated, renamed: "initialize(_:)")
	public func initialize(params: InitializeParams) async throws -> InitializationResponse {
		try await initialize(params)
	}

	public func initialize(_ params: InitializeParams) async throws -> InitializationResponse {
		try await sendRequest(.initialize(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "initialized(_:)")
	public func initialized(params: InitializedParams) async throws {
		try await initialized(params)
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

	@available(*, deprecated, renamed: "cancelRequest(_:)")
	public func cancelRequest(params: CancelParams) async throws {
		try await cancelRequest(params)
	}

	public func cancelRequest(_ params: CancelParams) async throws {
		try await sendNotification(.protocolCancelRequest(params))
	}

	@available(*, deprecated, renamed: "setTrace(_:)")
	public func setTrace(params: SetTraceParams) async throws {
		try await setTrace(params)
	}

	public func setTrace(_ params: SetTraceParams) async throws {
		try await sendNotification(.protocolSetTrace(params))
	}

	@available(*, deprecated, renamed: "textDocumentDidOpen(_:)")
	public func textDocumentDidOpen(params: DidOpenTextDocumentParams) async throws {
		try await textDocumentDidOpen(params)
	}

	public func textDocumentDidOpen(_ params: DidOpenTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidOpen(params))
	}

	@available(
		*, deprecated, renamed: "textDocumentDidOpen",
		message: "This method has been renamed to better match the spec."
	)
	@available(*, deprecated, renamed: "didOpenTextDocument(_:)")
	public func didOpenTextDocument(params: DidOpenTextDocumentParams) async throws {
		try await didOpenTextDocument(params)
	}

	public func didOpenTextDocument(_ params: DidOpenTextDocumentParams) async throws {
		try await textDocumentDidOpen(params)
	}

	@available(*, deprecated, renamed: "textDocumentDidChange(_:)")
	public func textDocumentDidChange(params: DidChangeTextDocumentParams) async throws {
		try await textDocumentDidChange(params)
	}

	public func textDocumentDidChange(_ params: DidChangeTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidChange(params))
	}

	@available(
		*, deprecated, renamed: "textDocumentDidChange",
		message: "This method has been renamed to better match the spec."
	)
	@available(*, deprecated, renamed: "didChangeTextDocument(_:)")
	public func didChangeTextDocument(params: DidChangeTextDocumentParams) async throws {
		try await didChangeTextDocument(params)
	}

	public func didChangeTextDocument(_ params: DidChangeTextDocumentParams) async throws {
		try await textDocumentDidChange(params)
	}

	@available(*, deprecated, renamed: "textDocumentDidClose(_:)")
	public func textDocumentDidClose(params: DidCloseTextDocumentParams) async throws {
		try await textDocumentDidClose(params)
	}

	public func textDocumentDidClose(_ params: DidCloseTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidClose(params))
	}

	@available(
		*, deprecated, renamed: "didCloseTextDocument",
		message: "This method has been renamed to better match the spec."
	)
	@available(*, deprecated, renamed: "didCloseTextDocument(_:)")
	public func didCloseTextDocument(params: DidCloseTextDocumentParams) async throws {
		try await didCloseTextDocument(params)
	}

	public func didCloseTextDocument(_ params: DidCloseTextDocumentParams) async throws {
		try await textDocumentDidClose(params)
	}

	@available(*, deprecated, renamed: "textDocumentWillSave(_:)")
	public func textDocumentWillSave(params: WillSaveTextDocumentParams) async throws {
		try await textDocumentWillSave(params)
	}

	public func textDocumentWillSave(_ params: WillSaveTextDocumentParams) async throws {
		try await sendNotification(.textDocumentWillSave(params))
	}

	@available(
		*, deprecated, renamed: "textDocumentWillSave",
		message: "This method has been renamed to better match the spec."
	)
	@available(*, deprecated, renamed: "willSaveTextDocument(_:)")
	public func willSaveTextDocument(params: WillSaveTextDocumentParams) async throws {
		try await willSaveTextDocument(params)
	}

	public func willSaveTextDocument(_ params: WillSaveTextDocumentParams) async throws {
		try await textDocumentWillSave(params)
	}

	@available(*, deprecated, renamed: "textDocumentWillSaveWaitUntil(_:)")
	public func textDocumentWillSaveWaitUntil(params: WillSaveTextDocumentParams) async throws
		-> WillSaveWaitUntilResponse
	{
		try await textDocumentWillSaveWaitUntil(params)
	}

	public func textDocumentWillSaveWaitUntil(_ params: WillSaveTextDocumentParams) async throws
		-> WillSaveWaitUntilResponse
	{
		try await sendRequest(.textDocumentWillSaveWaitUntil(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "textDocumentDidSave(_:)")
	public func textDocumentDidSave(params: DidSaveTextDocumentParams) async throws {
		try await textDocumentDidSave(params)
	}

	public func textDocumentDidSave(_ params: DidSaveTextDocumentParams) async throws {
		try await sendNotification(.textDocumentDidSave(params))
	}

	@available(*, deprecated, renamed: "workspaceDidChangeWatchedFiles(_:)")
	public func workspaceDidChangeWatchedFiles(params: DidChangeWatchedFilesParams) async throws {
		try await workspaceDidChangeWatchedFiles(params)
	}

	public func workspaceDidChangeWatchedFiles(_ params: DidChangeWatchedFilesParams) async throws {
		try await sendNotification(.workspaceDidChangeWatchedFiles(params))
	}

	@available(
		*, deprecated, renamed: "workspaceDidChangeWatchedFiles",
		message: "This method has been renamed to better match the spec."
	)
	@available(*, deprecated, renamed: "didChangeWatchedFiles(_:)")
	public func didChangeWatchedFiles(params: DidChangeWatchedFilesParams) async throws {
		try await didChangeWatchedFiles(params)
	}

	public func didChangeWatchedFiles(_ params: DidChangeWatchedFilesParams) async throws {
		try await workspaceDidChangeWatchedFiles(params)
	}

	@available(*, deprecated, renamed: "callHierarchyIncomingCalls(_:)")
	public func callHierarchyIncomingCalls(params: CallHierarchyIncomingCallsParams) async throws
		-> CallHierarchyIncomingCallsResponse
	{
		try await callHierarchyIncomingCalls(params)
	}

	public func callHierarchyIncomingCalls(_ params: CallHierarchyIncomingCallsParams) async throws
		-> CallHierarchyIncomingCallsResponse
	{
		try await sendRequest(.callHierarchyIncomingCalls(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "callHierarchyOutgoingCalls(_:)")
	public func callHierarchyOutgoingCalls(params: CallHierarchyOutgoingCallsParams) async throws
		-> CallHierarchyOutgoingCallsResponse
	{
		try await callHierarchyOutgoingCalls(params)
	}

	public func callHierarchyOutgoingCalls(_ params: CallHierarchyOutgoingCallsParams) async throws
		-> CallHierarchyOutgoingCallsResponse
	{
		try await sendRequest(.callHierarchyOutgoingCalls(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "completion(_:)")
	public func completion(params: CompletionParams) async throws -> CompletionResponse {
		try await completion(params)
	}

	public func completion(_ params: CompletionParams) async throws -> CompletionResponse {
		try await sendRequest(.completion(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "hover(_:)")
	public func hover(params: TextDocumentPositionParams) async throws -> HoverResponse {
		try await hover(params)
	}

	public func hover(_ params: TextDocumentPositionParams) async throws -> HoverResponse {
		try await sendRequest(.hover(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "signatureHelp(_:)")
	public func signatureHelp(params: TextDocumentPositionParams) async throws
		-> SignatureHelpResponse
	{
		try await signatureHelp(params)
	}

	public func signatureHelp(_ params: TextDocumentPositionParams) async throws
		-> SignatureHelpResponse
	{
		try await sendRequest(.signatureHelp(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "declaration(_:)")
	public func declaration(params: TextDocumentPositionParams) async throws -> DeclarationResponse
	{
		try await declaration(params)
	}

	public func declaration(_ params: TextDocumentPositionParams) async throws -> DeclarationResponse
	{
		try await sendRequest(.declaration(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "definition(_:)")
	public func definition(params: TextDocumentPositionParams) async throws -> DefinitionResponse {
		try await definition(params)
	}

	public func definition(_ params: TextDocumentPositionParams) async throws -> DefinitionResponse {
		try await sendRequest(.definition(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "typeDefinition(_:)")
	public func typeDefinition(params: TextDocumentPositionParams) async throws
		-> TypeDefinitionResponse
	{
		try await typeDefinition(params)
	}

	public func typeDefinition(_ params: TextDocumentPositionParams) async throws
		-> TypeDefinitionResponse
	{
		try await sendRequest(.typeDefinition(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "implementation(_:)")
	public func implementation(params: TextDocumentPositionParams) async throws
		-> ImplementationResponse
	{
		try await implementation(params)
	}

	public func implementation(_ params: TextDocumentPositionParams) async throws
		-> ImplementationResponse
	{
		try await sendRequest(.implementation(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "documentSymbol(_:)")
	public func documentSymbol(params: DocumentSymbolParams) async throws -> DocumentSymbolResponse
	{
		try await documentSymbol(params)
	}

	public func documentSymbol(_ params: DocumentSymbolParams) async throws -> DocumentSymbolResponse
	{
		try await sendRequest(.documentSymbol(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "prepareCallHierarchy(_:)")
	public func prepareCallHierarchy(params: CallHierarchyPrepareParams) async throws
		-> CallHierarchyPrepareResponse
	{
		try await prepareCallHierarchy(params)
	}

	public func prepareCallHierarchy(_ params: CallHierarchyPrepareParams) async throws
		-> CallHierarchyPrepareResponse
	{
		try await sendRequest(.prepareCallHierarchy(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "prepareRename(_:)")
	public func prepareRename(params: PrepareRenameParams) async throws -> PrepareRenameResponse {
		try await prepareRename(params)
	}

	public func prepareRename(_ params: PrepareRenameParams) async throws -> PrepareRenameResponse {
		try await sendRequest(.prepareRename(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "prepareTypeHeirarchy(_:)")
	public func prepareTypeHeirarchy(params: TypeHierarchyPrepareParams) async throws
		-> PrepareTypeHeirarchyResponse
	{
		try await prepareTypeHeirarchy(params)
	}

	public func prepareTypeHeirarchy(_ params: TypeHierarchyPrepareParams) async throws
		-> PrepareTypeHeirarchyResponse
	{
		try await sendRequest(.prepareTypeHierarchy(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "rename(_:)")
	public func rename(params: RenameParams) async throws -> RenameResponse {
		try await rename(params)
	}

	public func rename(_ params: RenameParams) async throws -> RenameResponse {
		try await sendRequest(.rename(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "formatting(_:)")
	public func formatting(params: DocumentFormattingParams) async throws -> FormattingResult {
		try await formatting(params)
	}

	public func formatting(_ params: DocumentFormattingParams) async throws -> FormattingResult {
		try await sendRequest(.formatting(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "rangeFormatting(_:)")
	public func rangeFormatting(params: DocumentRangeFormattingParams) async throws
		-> FormattingResult
	{
		try await rangeFormatting(params)
	}

	public func rangeFormatting(_ params: DocumentRangeFormattingParams) async throws
		-> FormattingResult
	{
		try await sendRequest(.rangeFormatting(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "onTypeFormatting(_:)")
	public func onTypeFormatting(params: DocumentOnTypeFormattingParams) async throws
		-> FormattingResult
	{
		try await onTypeFormatting(params)
	}

	public func onTypeFormatting(_ params: DocumentOnTypeFormattingParams) async throws
		-> FormattingResult
	{
		try await sendRequest(.onTypeFormatting(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "references(_:)")
	public func references(params: ReferenceParams) async throws -> ReferenceResponse {
		try await references(params)
	}

	public func references(_ params: ReferenceParams) async throws -> ReferenceResponse {
		try await sendRequest(.references(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "foldingRange(_:)")
	public func foldingRange(params: FoldingRangeParams) async throws -> FoldingRangeResponse {
		try await foldingRange(params)
	}

	public func foldingRange(_ params: FoldingRangeParams) async throws -> FoldingRangeResponse {
		try await sendRequest(.foldingRange(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "semanticTokensFull(_:)")
	public func semanticTokensFull(params: SemanticTokensParams) async throws
		-> SemanticTokensResponse
	{
		try await semanticTokensFull(params)
	}

	public func semanticTokensFull(_ params: SemanticTokensParams) async throws
		-> SemanticTokensResponse
	{
		try await sendRequest(.semanticTokensFull(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "semanticTokensFullDelta(_:)")
	public func semanticTokensFullDelta(params: SemanticTokensDeltaParams) async throws
		-> SemanticTokensDeltaResponse
	{
		try await semanticTokensFullDelta(params)
	}

	public func semanticTokensFullDelta(_ params: SemanticTokensDeltaParams) async throws
		-> SemanticTokensDeltaResponse
	{
		try await sendRequest(.semanticTokensFullDelta(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "semanticTokensRange(_:)")
	public func semanticTokensRange(params: SemanticTokensRangeParams) async throws
		-> SemanticTokensResponse
	{
		try await semanticTokensRange(params)
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
	@available(*, deprecated, renamed: "didChangeWorkspaceFolders(_:)")
	public func didChangeWorkspaceFolders(params: DidChangeWorkspaceFoldersParams) async throws {
		try await didChangeWorkspaceFolders(params)
	}

	public func didChangeWorkspaceFolders(_ params: DidChangeWorkspaceFoldersParams) async throws {
		try await sendNotification(.workspaceDidChangeWorkspaceFolders(params))
	}

	@available(*, deprecated, renamed: "didChangeConfiguration(_:)")
	public func didChangeConfiguration(params: DidChangeConfigurationParams) async throws {
		try await didChangeConfiguration(params)
	}

	public func didChangeConfiguration(_ params: DidChangeConfigurationParams) async throws {
		try await sendNotification(.workspaceDidChangeConfiguration(params))
	}

	@available(*, deprecated, renamed: "didCreateFiles(_:)")
	public func didCreateFiles(params: CreateFilesParams) async throws {
		try await didCreateFiles(params)
	}

	public func didCreateFiles(_ params: CreateFilesParams) async throws {
		try await sendNotification(.workspaceDidCreateFiles(params))
	}

	@available(*, deprecated, renamed: "didRenameFiles(_:)")
	public func didRenameFiles(params: RenameFilesParams) async throws {
		try await didRenameFiles(params)
	}

	public func didRenameFiles(_ params: RenameFilesParams) async throws {
		try await sendNotification(.workspaceDidRenameFiles(params))
	}

	@available(*, deprecated, renamed: "didDeleteFiles(_:)")
	public func didDeleteFiles(params: DeleteFilesParams) async throws {
		try await didDeleteFiles(params)
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

	@available(*, deprecated, renamed: "willCreateFiles(_:)")
	public func willCreateFiles(params: CreateFilesParams) async throws
		-> WorkspaceWillCreateFilesResponse
	{
		try await willCreateFiles(params)
	}

	public func willCreateFiles(_ params: CreateFilesParams) async throws
		-> WorkspaceWillCreateFilesResponse
	{
		try await sendRequest(.workspaceWillCreateFiles(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "willRenameFiles(_:)")
	public func willRenameFiles(params: RenameFilesParams) async throws
		-> WorkspaceWillRenameFilesResponse
	{
		try await willRenameFiles(params)
	}

	public func willRenameFiles(_ params: RenameFilesParams) async throws
		-> WorkspaceWillRenameFilesResponse
	{
		try await sendRequest(.workspaceWillRenameFiles(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "willDeleteFiles(_:)")
	public func willDeleteFiles(params: DeleteFilesParams) async throws
		-> WorkspaceWillDeleteFilesResponse
	{
		try await willDeleteFiles(params)
	}

	public func willDeleteFiles(_ params: DeleteFilesParams) async throws
		-> WorkspaceWillDeleteFilesResponse
	{
		try await sendRequest(.workspaceWillDeleteFiles(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "executeCommand(_:)")
	public func executeCommand(params: ExecuteCommandParams) async throws -> ExecuteCommandResponse
	{
		try await executeCommand(params)
	}

	public func executeCommand(_ params: ExecuteCommandParams) async throws -> ExecuteCommandResponse
	{
		try await sendRequest(.workspaceExecuteCommand(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "workspaceSymbol(_:)")
	public func workspaceSymbol(params: WorkspaceSymbolParams) async throws
		-> WorkspaceSymbolResponse
	{
		try await workspaceSymbol(params)
	}

	public func workspaceSymbol(_ params: WorkspaceSymbolParams) async throws
		-> WorkspaceSymbolResponse
	{
		try await sendRequest(.workspaceSymbol(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "workspaceSymbolResolve(_:)")
	public func workspaceSymbolResolve(params: WorkspaceSymbol) async throws
		-> WorkspaceSymbolResponse
	{
		try await workspaceSymbolResolve(params)
	}

	public func workspaceSymbolResolve(_ params: WorkspaceSymbol) async throws
		-> WorkspaceSymbolResponse
	{
		try await sendRequest(.workspaceSymbolResolve(params, ClientRequest.NullHandler))
	}
}

// Language Features
extension ServerConnection {
	@available(*, deprecated, renamed: "documentHighlight(_:)")
	public func documentHighlight(params: DocumentHighlightParams) async throws
		-> DocumentHighlightResponse
	{
		try await documentHighlight(params)
	}

	public func documentHighlight(_ params: DocumentHighlightParams) async throws
		-> DocumentHighlightResponse
	{
		try await sendRequest(.documentHighlight(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "codeAction(_:)")
	public func codeAction(params: CodeActionParams) async throws -> CodeActionResponse {
		try await codeAction(params)
	}

	public func codeAction(_ params: CodeActionParams) async throws -> CodeActionResponse {
		try await sendRequest(.codeAction(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "codeActionResolve(_:)")
	public func codeActionResolve(params: CodeAction) async throws -> CodeAction {
		try await codeActionResolve(params)
	}

	public func codeActionResolve(_ params: CodeAction) async throws -> CodeAction {
		try await sendRequest(.codeActionResolve(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "codeLens(_:)")
	public func codeLens(params: CodeLensParams) async throws -> CodeLensResponse {
		try await codeLens(params)
	}

	public func codeLens(_ params: CodeLensParams) async throws -> CodeLensResponse {
		try await sendRequest(.codeLens(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "codeLensResolve(_:)")
	public func codeLensResolve(params: CodeLens) async throws -> CodeLensResolveResponse {
		try await codeLensResolve(params)
	}

	public func codeLensResolve(_ params: CodeLens) async throws -> CodeLensResolveResponse {
		try await sendRequest(.codeLensResolve(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "diagnostics(_:)")
	public func diagnostics(params: DocumentDiagnosticParams) async throws
		-> DocumentDiagnosticReport
	{
		try await diagnostics(params)
	}

	public func diagnostics(_ params: DocumentDiagnosticParams) async throws
		-> DocumentDiagnosticReport
	{
		try await sendRequest(.diagnostics(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "selectionRange(_:)")
	public func selectionRange(params: SelectionRangeParams) async throws -> SelectionRangeResponse
	{
		try await selectionRange(params)
	}

	public func selectionRange(_ params: SelectionRangeParams) async throws -> SelectionRangeResponse
	{
		try await sendRequest(.selectionRange(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "documentLink(_:)")
	public func documentLink(params: DocumentLinkParams) async throws -> DocumentLinkResponse {
		try await documentLink(params)
	}

	public func documentLink(_ params: DocumentLinkParams) async throws -> DocumentLinkResponse {
		try await sendRequest(.documentLink(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "documentLinkResolve(_:)")
	public func documentLinkResolve(params: DocumentLink) async throws -> DocumentLink {
		try await documentLinkResolve(params)
	}

	public func documentLinkResolve(_ params: DocumentLink) async throws -> DocumentLink {
		try await sendRequest(.documentLinkResolve(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "documentColor(_:)")
	public func documentColor(params: DocumentColorParams) async throws -> DocumentColorResponse {
		try await documentColor(params)
	}

	public func documentColor(_ params: DocumentColorParams) async throws -> DocumentColorResponse {
		try await sendRequest(.documentColor(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "colorPresentation(_:)")
	public func colorPresentation(params: ColorPresentationParams) async throws
		-> ColorPresentationResponse
	{
		try await colorPresentation(params)
	}

	public func colorPresentation(_ params: ColorPresentationParams) async throws
		-> ColorPresentationResponse
	{
		try await sendRequest(.colorPresentation(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "inlayHint(_:)")
	public func inlayHint(params: InlayHintParams) async throws -> InlayHintResponse {
		try await inlayHint(params)
	}

	public func inlayHint(_ params: InlayHintParams) async throws -> InlayHintResponse {
		try await sendRequest(.inlayHint(params, ClientRequest.NullHandler))
	}

	@available(*, deprecated, renamed: "inlayHintResolve(_:)")
	public func inlayHintResolve(params: InlayHint) async throws -> InlayHint {
		try await inlayHintResolve(params)
	}

	public func inlayHintResolve(_ params: InlayHint) async throws -> InlayHint {
		try await sendRequest(.inlayHintResolve(params, ClientRequest.NullHandler))
	}
}
