import Foundation
import JSONRPC
import LanguageServerProtocol

public protocol RequestHandler : ErrorHandler {
	typealias Handler = ClientRequest.Handler
	typealias Response<T> = Result<T, AnyJSONRPCResponseError>

	func handleRequest(id: JSONId, request: ClientRequest) async

	func initialize(id: JSONId, params: InitializeParams) async -> Response<InitializationResponse>
	func shutdown(id: JSONId) async
	func workspaceInlayHintRefresh(id: JSONId) async
	func workspaceExecuteCommand(id: JSONId, params: ExecuteCommandParams) async -> Response<LSPAny?>
	func workspaceWillCreateFiles(id: JSONId, params: CreateFilesParams) async -> Response<WorkspaceEdit?>
	func workspaceWillRenameFiles(id: JSONId, params: RenameFilesParams) async -> Response<WorkspaceEdit?>
	func workspaceWillDeleteFiles(id: JSONId, params: DeleteFilesParams) async -> Response<WorkspaceEdit?>
	func workspaceSymbol(id: JSONId, params: WorkspaceSymbolParams) async -> Response<WorkspaceSymbolResponse>
	func workspaceSymbolResolve(id: JSONId, params: WorkspaceSymbol) async -> Response<WorkspaceSymbol>
	func textDocumentWillSaveWaitUntil(id: JSONId, params: WillSaveTextDocumentParams) async -> Response<[TextEdit]?>
	func completion(id: JSONId, params: CompletionParams) async -> Response<CompletionResponse>
	func completionItemResolve(id: JSONId, params: CompletionItem) async -> Response<CompletionItem>
	func hover(id: JSONId, params: TextDocumentPositionParams) async -> Response<HoverResponse>
	func signatureHelp(id: JSONId, params: TextDocumentPositionParams) async -> Response<SignatureHelpResponse>
	func declaration(id: JSONId, params: TextDocumentPositionParams) async -> Response<DeclarationResponse>
	func definition(id: JSONId, params: TextDocumentPositionParams) async -> Response<DefinitionResponse>
	func typeDefinition(id: JSONId, params: TextDocumentPositionParams) async -> Response<TypeDefinitionResponse>
	func implementation(id: JSONId, params: TextDocumentPositionParams) async -> Response<ImplementationResponse>
	func diagnostics(id: JSONId, params: DocumentDiagnosticParams) async -> Response<DocumentDiagnosticReport>
	func documentHighlight(id: JSONId, params: DocumentHighlightParams) async -> Response<DocumentHighlightResponse>
	func documentSymbol(id: JSONId, params: DocumentSymbolParams) async -> Response<DocumentSymbolResponse>
	func codeAction(id: JSONId, params: CodeActionParams) async -> Response<CodeActionResponse>
	func codeActionResolve(id: JSONId, params: CodeAction) async -> Response<CodeAction>
	func codeLens(id: JSONId, params: CodeLensParams) async -> Response<CodeLensResponse>
	func codeLensResolve(id: JSONId, params: CodeLens) async -> Response<CodeLens>
	func selectionRange(id: JSONId, params: SelectionRangeParams) async -> Response<SelectionRangeResponse>
	func linkedEditingRange(id: JSONId, params: LinkedEditingRangeParams) async -> Response<LinkedEditingRangeResponse>
	func prepareCallHierarchy(id: JSONId, params: CallHierarchyPrepareParams) async -> Response<CallHierarchyPrepareResponse>
	func prepareRename(id: JSONId, params: PrepareRenameParams) async -> Response<PrepareRenameResponse>
	func prepareTypeHeirarchy(id: JSONId, params: TypeHierarchyPrepareParams) async -> Response<PrepareTypeHeirarchyResponse>
	func rename(id: JSONId, params: RenameParams) async -> Response<RenameResponse>
	func documentLink(id: JSONId, params: DocumentLinkParams) async -> Response<DocumentLinkResponse>
	func documentLinkResolve(id: JSONId, params: DocumentLink) async -> Response<DocumentLink>
	func documentColor(id: JSONId, params: DocumentColorParams) async -> Response<DocumentColorResponse>
	func colorPresentation(id: JSONId, params: ColorPresentationParams) async -> Response<ColorPresentationResponse>
	func formatting(id: JSONId, params: DocumentFormattingParams) async -> Response<FormattingResult>
	func rangeFormatting(id: JSONId, params: DocumentRangeFormattingParams) async -> Response<FormattingResult>
	func onTypeFormatting(id: JSONId, params: DocumentOnTypeFormattingParams) async -> Response<FormattingResult>
	func references(id: JSONId, params: ReferenceParams) async -> Response<ReferenceResponse>
	func foldingRange(id: JSONId, params: FoldingRangeParams) async -> Response<FoldingRangeResponse>
	func moniker(id: JSONId, params: MonikerParams) async -> Response<MonikerResponse>
	func semanticTokensFull(id: JSONId, params: SemanticTokensParams) async -> Response<SemanticTokensResponse>
	func semanticTokensFullDelta(id: JSONId, params: SemanticTokensDeltaParams) async -> Response<SemanticTokensDeltaResponse>
	func semanticTokensRange(id: JSONId, params: SemanticTokensRangeParams) async -> Response<SemanticTokensResponse>
	func callHierarchyIncomingCalls(id: JSONId, params: CallHierarchyIncomingCallsParams) async -> Response<CallHierarchyIncomingCallsResponse>
	func callHierarchyOutgoingCalls(id: JSONId, params: CallHierarchyOutgoingCallsParams) async -> Response<CallHierarchyOutgoingCallsResponse>
	func custom(id: JSONId, method: String, params: LSPAny) async -> Response<LSPAny>
}


public extension RequestHandler {
	func handleRequest(id: JSONId, request: ClientRequest) async {
		await defaultRequestDispatch(id: id, request: request)
	}

	func defaultRequestDispatch(id: JSONId, request: ClientRequest) async {

		switch request {
		case let .initialize(params, handler):
			await handler(await initialize(id: id, params: params))
		case let .shutdown(handler):
			await shutdown(id: id)
			await handler(.success(nil))
		case let .workspaceInlayHintRefresh(handler):
			await workspaceInlayHintRefresh(id: id)
			await handler(.success(nil))
		case let .workspaceExecuteCommand(params, handler):
			await handler(await workspaceExecuteCommand(id: id, params: params))
		case let .workspaceWillCreateFiles(params, handler):
			await handler(await workspaceWillCreateFiles(id: id, params: params))
		case let .workspaceWillRenameFiles(params, handler):
			await handler(await workspaceWillRenameFiles(id: id, params: params))
		case let .workspaceWillDeleteFiles(params, handler):
			await handler(await workspaceWillDeleteFiles(id: id, params: params))
		case let .workspaceSymbol(params, handler):
			await handler(await workspaceSymbol(id: id, params: params))
		case let .workspaceSymbolResolve(params, handler):
			await handler(await workspaceSymbolResolve(id: id, params: params))
		case let .textDocumentWillSaveWaitUntil(params, handler):
			await handler(await textDocumentWillSaveWaitUntil(id: id, params: params))
		case let .completion(params, handler):
			await handler(await completion(id: id, params: params))
		case let .completionItemResolve(params, handler):
			await handler(await completionItemResolve(id: id, params: params))
		case let .hover(params, handler):
			await handler(await hover(id: id, params: params))
		case let .signatureHelp(params, handler):
			await handler(await signatureHelp(id: id, params: params))
		case let .declaration(params, handler):
			await handler(await declaration(id: id, params: params))
		case let .definition(params, handler):
			await handler(await definition(id: id, params: params))
		case let .typeDefinition(params, handler):
			await handler(await typeDefinition(id: id, params: params))
		case let .implementation(params, handler):
			await handler(await implementation(id: id, params: params))
		case let .diagnostics(params, handler):
			await handler(await diagnostics(id: id, params: params))
		case let .documentHighlight(params, handler):
			await handler(await documentHighlight(id: id, params: params))
		case let .documentSymbol(params, handler):
			await handler(await documentSymbol(id: id, params: params))
		case let .codeAction(params, handler):
			await handler(await codeAction(id: id, params: params))
		case let .codeActionResolve(params, handler):
			await handler(await codeActionResolve(id: id, params: params))
		case let .codeLens(params, handler):
			await handler(await codeLens(id: id, params: params))
		case let .codeLensResolve(params, handler):
			await handler(await codeLensResolve(id: id, params: params))
		case let .selectionRange(params, handler):
			await handler(await selectionRange(id: id, params: params))
		case let .linkedEditingRange(params, handler):
			await handler(await linkedEditingRange(id: id, params: params))
		case let .prepareCallHierarchy(params, handler):
			await handler(await prepareCallHierarchy(id: id, params: params))
		case let .prepareRename(params, handler):
			await handler(await prepareRename(id: id, params: params))
		case let .prepareTypeHierarchy(params, handler):
			await handler(await prepareTypeHeirarchy(id: id, params: params))
		case let .rename(params, handler):
			await handler(await rename(id: id, params: params))
		case let .inlayHint(params, handler):
			await handler(await inlayHint(id: id, params: params))
		case let .inlayHintResolve(params, handler):
			await handler(await inlayHintResolve(id: id, params: params))
		case let .documentLink(params, handler):
			await handler(await documentLink(id: id, params: params))
		case let .documentLinkResolve(params, handler):
			await handler(await documentLinkResolve(id: id, params: params))
		case let .documentColor(params, handler):
			await handler(await documentColor(id: id, params: params))
		case let .colorPresentation(params, handler):
			await handler(await colorPresentation(id: id, params: params))
		case let .formatting(params, handler):
			await handler(await formatting(id: id, params: params))
		case let .rangeFormatting(params, handler):
			await handler(await rangeFormatting(id: id, params: params))
		case let .onTypeFormatting(params, handler):
			await handler(await onTypeFormatting(id: id, params: params))
		case let .references(params, handler):
			await handler(await references(id: id, params: params))
		case let .foldingRange(params, handler):
			await handler(await foldingRange(id: id, params: params))
		case let .moniker(params, handler):
			await handler(await moniker(id: id, params: params))
		case let .semanticTokensFull(params, handler):
			await handler(await semanticTokensFull(id: id, params: params))
		case let .semanticTokensFullDelta(params, handler):
			await handler(await semanticTokensFullDelta(id: id, params: params))
		case let .semanticTokensRange(params, handler):
			await handler(await semanticTokensRange(id: id, params: params))
		case let .callHierarchyIncomingCalls(params, handler):
			await handler(await callHierarchyIncomingCalls(id: id, params: params))
		case let .callHierarchyOutgoingCalls(params, handler):
			await handler(await callHierarchyOutgoingCalls(id: id, params: params))
		case let .custom(method, params, handler):
			await handler(await custom(id: id, method: method, params: params))
		}
	}
}


let NotImplementedError = AnyJSONRPCResponseError(code: ErrorCodes.InternalError, message: "Not implemented")

/// Provide default implementations for all protocol methods
/// We do this since the handler only need to support a subset, based on dynamically registered capabilities
public extension RequestHandler {

	func initialize(id: JSONId, params: InitializeParams) async -> Response<InitializationResponse> { .failure(NotImplementedError) }
	func shutdown(id: JSONId) async { }
	func workspaceInlayHintRefresh(id: JSONId) async { }
	func workspaceExecuteCommand(id: JSONId, params: ExecuteCommandParams) async -> Response<LSPAny?> { .failure(NotImplementedError) }
	func workspaceWillCreateFiles(id: JSONId, params: CreateFilesParams) async -> Response<WorkspaceEdit?> { .failure(NotImplementedError) }
	func workspaceWillRenameFiles(id: JSONId, params: RenameFilesParams) async -> Response<WorkspaceEdit?> { .failure(NotImplementedError) }
	func workspaceWillDeleteFiles(id: JSONId, params: DeleteFilesParams) async -> Response<WorkspaceEdit?> { .failure(NotImplementedError) }
	func workspaceSymbol(id: JSONId, params: WorkspaceSymbolParams) async -> Response<WorkspaceSymbolResponse> { .failure(NotImplementedError) }
	func workspaceSymbolResolve(id: JSONId, params: WorkspaceSymbol) async -> Response<WorkspaceSymbol> { .failure(NotImplementedError) }
	func textDocumentWillSaveWaitUntil(id: JSONId, params: WillSaveTextDocumentParams) async -> Response<[TextEdit]?> { .failure(NotImplementedError) }
	func completion(id: JSONId, params: CompletionParams) async -> Response<CompletionResponse> { .failure(NotImplementedError) }
	func completionItemResolve(id: JSONId, params: CompletionItem) async -> Response<CompletionItem> { .failure(NotImplementedError) }
	func hover(id: JSONId, params: TextDocumentPositionParams) async -> Response<HoverResponse> { .failure(NotImplementedError) }
	func signatureHelp(id: JSONId, params: TextDocumentPositionParams) async -> Response<SignatureHelpResponse> { .failure(NotImplementedError) }
	func declaration(id: JSONId, params: TextDocumentPositionParams) async -> Response<DeclarationResponse> { .failure(NotImplementedError) }
	func definition(id: JSONId, params: TextDocumentPositionParams) async -> Response<DefinitionResponse> { .failure(NotImplementedError) }
	func typeDefinition(id: JSONId, params: TextDocumentPositionParams) async -> Response<TypeDefinitionResponse> { .failure(NotImplementedError) }
	func implementation(id: JSONId, params: TextDocumentPositionParams) async -> Response<ImplementationResponse> { .failure(NotImplementedError) }
	func diagnostics(id: JSONId, params: DocumentDiagnosticParams) async -> Response<DocumentDiagnosticReport> { .failure(NotImplementedError) }
	func documentHighlight(id: JSONId, params: DocumentHighlightParams) async -> Response<DocumentHighlightResponse> { .failure(NotImplementedError) }
	func documentSymbol(id: JSONId, params: DocumentSymbolParams) async -> Response<DocumentSymbolResponse> { .failure(NotImplementedError) }
	func codeAction(id: JSONId, params: CodeActionParams) async -> Response<CodeActionResponse> { .failure(NotImplementedError) }
	func codeActionResolve(id: JSONId, params: CodeAction) async -> Response<CodeAction> { .failure(NotImplementedError) }
	func codeLens(id: JSONId, params: CodeLensParams) async -> Response<CodeLensResponse> { .failure(NotImplementedError) }
	func codeLensResolve(id: JSONId, params: CodeLens) async -> Response<CodeLens> { .failure(NotImplementedError) }
	func selectionRange(id: JSONId, params: SelectionRangeParams) async -> Response<SelectionRangeResponse> { .failure(NotImplementedError) }
	func linkedEditingRange(id: JSONId, params: LinkedEditingRangeParams) async -> Response<LinkedEditingRangeResponse> { .failure(NotImplementedError) }
	func prepareCallHierarchy(id: JSONId, params: CallHierarchyPrepareParams) async -> Response<CallHierarchyPrepareResponse> { .failure(NotImplementedError) }
	func prepareRename(id: JSONId, params: PrepareRenameParams) async -> Response<PrepareRenameResponse> { .failure(NotImplementedError) }
	func prepareTypeHeirarchy(id: JSONId, params: TypeHierarchyPrepareParams) async -> Response<PrepareTypeHeirarchyResponse> { .failure(NotImplementedError) }
	func rename(id: JSONId, params: RenameParams) async -> Response<RenameResponse> { .failure(NotImplementedError) }
	func inlayHint(id: JSONId, params: InlayHintParams) async -> Response<InlayHintResponse> { .failure(NotImplementedError) }
	func inlayHintResolve(id: JSONId, params: InlayHint) async -> Response<InlayHintResponse> { .failure(NotImplementedError) }
	func documentLink(id: JSONId, params: DocumentLinkParams) async -> Response<DocumentLinkResponse> { .failure(NotImplementedError) }
	func documentLinkResolve(id: JSONId, params: DocumentLink) async -> Response<DocumentLink> { .failure(NotImplementedError) }
	func documentColor(id: JSONId, params: DocumentColorParams) async -> Response<DocumentColorResponse> { .failure(NotImplementedError) }
	func colorPresentation(id: JSONId, params: ColorPresentationParams) async -> Response<ColorPresentationResponse> { .failure(NotImplementedError) }
	func formatting(id: JSONId, params: DocumentFormattingParams) async -> Response<FormattingResult> { .failure(NotImplementedError) }
	func rangeFormatting(id: JSONId, params: DocumentRangeFormattingParams) async -> Response<FormattingResult> { .failure(NotImplementedError) }
	func onTypeFormatting(id: JSONId, params: DocumentOnTypeFormattingParams) async -> Response<FormattingResult> { .failure(NotImplementedError) }
	func references(id: JSONId, params: ReferenceParams) async -> Response<ReferenceResponse> { .failure(NotImplementedError) }
	func foldingRange(id: JSONId, params: FoldingRangeParams) async -> Response<FoldingRangeResponse> { .failure(NotImplementedError) }
	func moniker(id: JSONId, params: MonikerParams) async -> Response<MonikerResponse> { .failure(NotImplementedError) }
	func semanticTokensFull(id: JSONId, params: SemanticTokensParams) async -> Response<SemanticTokensResponse> { .failure(NotImplementedError) }
	func semanticTokensFullDelta(id: JSONId, params: SemanticTokensDeltaParams) async -> Response<SemanticTokensDeltaResponse> { .failure(NotImplementedError) }
	func semanticTokensRange(id: JSONId, params: SemanticTokensRangeParams) async -> Response<SemanticTokensResponse> { .failure(NotImplementedError) }
	func callHierarchyIncomingCalls(id: JSONId, params: CallHierarchyIncomingCallsParams) async -> Response<CallHierarchyIncomingCallsResponse> { .failure(NotImplementedError) }
	func callHierarchyOutgoingCalls(id: JSONId, params: CallHierarchyOutgoingCallsParams) async -> Response<CallHierarchyOutgoingCallsResponse> { .failure(NotImplementedError) }
	func custom(id: JSONId, method: String, params: LSPAny) async -> Response<LSPAny> { .failure(NotImplementedError) }
}
