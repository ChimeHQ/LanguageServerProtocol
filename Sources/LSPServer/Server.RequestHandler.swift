import Foundation
import JSONRPC
import LanguageServerProtocol


public protocol RequestHandler : ErrorHandler {
	typealias Handler = ClientRequest.Handler;

	func handleRequest(id: JSONId, request: ClientRequest) async

	func initialize(id: JSONId, params: InitializeParams) async -> Result<InitializationResponse, AnyJSONRPCResponseError>
	func shutdown(id: JSONId) async
	func workspaceInlayHintRefresh(id: JSONId) async
	func workspaceExecuteCommand(id: JSONId, params: ExecuteCommandParams) async -> Result<LSPAny?, AnyJSONRPCResponseError>
	func workspaceWillCreateFiles(id: JSONId, params: CreateFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError>
	func workspaceWillRenameFiles(id: JSONId, params: RenameFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError>
	func workspaceWillDeleteFiles(id: JSONId, params: DeleteFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError>
	func workspaceSymbol(id: JSONId, params: WorkspaceSymbolParams) async -> Result<WorkspaceSymbolResponse, AnyJSONRPCResponseError>
	func workspaceSymbolResolve(id: JSONId, params: WorkspaceSymbol) async -> Result<WorkspaceSymbol, AnyJSONRPCResponseError>
	func textDocumentWillSaveWaitUntil(id: JSONId, params: WillSaveTextDocumentParams) async -> Result<[TextEdit]?, AnyJSONRPCResponseError>
	func completion(id: JSONId, params: CompletionParams) async -> Result<CompletionResponse, AnyJSONRPCResponseError>
	func completionItemResolve(id: JSONId, params: CompletionItem) async -> Result<CompletionItem, AnyJSONRPCResponseError>
	func hover(id: JSONId, params: TextDocumentPositionParams) async -> Result<HoverResponse, AnyJSONRPCResponseError>
	func signatureHelp(id: JSONId, params: TextDocumentPositionParams) async -> Result<SignatureHelpResponse, AnyJSONRPCResponseError>
	func declaration(id: JSONId, params: TextDocumentPositionParams) async -> Result<DeclarationResponse, AnyJSONRPCResponseError>
	func definition(id: JSONId, params: TextDocumentPositionParams) async -> Result<DefinitionResponse, AnyJSONRPCResponseError>
	func typeDefinition(id: JSONId, params: TextDocumentPositionParams) async -> Result<TypeDefinitionResponse, AnyJSONRPCResponseError>
	func implementation(id: JSONId, params: TextDocumentPositionParams) async -> Result<ImplementationResponse, AnyJSONRPCResponseError>
	func diagnostics(id: JSONId, params: DocumentDiagnosticParams) async -> Result<DocumentDiagnosticReport, AnyJSONRPCResponseError>
	func documentHighlight(id: JSONId, params: DocumentHighlightParams) async -> Result<DocumentHighlightResponse, AnyJSONRPCResponseError>
	func documentSymbol(id: JSONId, params: DocumentSymbolParams) async -> Result<DocumentSymbolResponse, AnyJSONRPCResponseError>
	func codeAction(id: JSONId, params: CodeActionParams) async -> Result<CodeActionResponse, AnyJSONRPCResponseError>
	func codeActionResolve(id: JSONId, params: CodeAction) async -> Result<CodeAction, AnyJSONRPCResponseError>
	func codeLens(id: JSONId, params: CodeLensParams) async -> Result<CodeLensResponse, AnyJSONRPCResponseError>
	func codeLensResolve(id: JSONId, params: CodeLens) async -> Result<CodeLens, AnyJSONRPCResponseError>
	func selectionRange(id: JSONId, params: SelectionRangeParams) async -> Result<SelectionRangeResponse, AnyJSONRPCResponseError>
	func linkedEditingRange(id: JSONId, params: LinkedEditingRangeParams) async -> Result<LinkedEditingRangeResponse, AnyJSONRPCResponseError>
	func prepareCallHierarchy(id: JSONId, params: CallHierarchyPrepareParams) async -> Result<CallHierarchyPrepareResponse, AnyJSONRPCResponseError>
	func prepareRename(id: JSONId, params: PrepareRenameParams) async -> Result<PrepareRenameResponse, AnyJSONRPCResponseError>
	func rename(id: JSONId, params: RenameParams) async -> Result<RenameResponse, AnyJSONRPCResponseError>
	func documentLink(id: JSONId, params: DocumentLinkParams) async -> Result<DocumentLinkResponse, AnyJSONRPCResponseError>
	func documentLinkResolve(id: JSONId, params: DocumentLink) async -> Result<DocumentLink, AnyJSONRPCResponseError>
	func documentColor(id: JSONId, params: DocumentColorParams) async -> Result<DocumentColorResponse, AnyJSONRPCResponseError>
	func colorPresentation(id: JSONId, params: ColorPresentationParams) async -> Result<ColorPresentationResponse, AnyJSONRPCResponseError>
	func formatting(id: JSONId, params: DocumentFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError>
	func rangeFormatting(id: JSONId, params: DocumentRangeFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError>
	func onTypeFormatting(id: JSONId, params: DocumentOnTypeFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError>
	func references(id: JSONId, params: ReferenceParams) async -> Result<ReferenceResponse, AnyJSONRPCResponseError>
	func foldingRange(id: JSONId, params: FoldingRangeParams) async -> Result<FoldingRangeResponse, AnyJSONRPCResponseError>
	func moniker(id: JSONId, params: MonkierParams) async -> Result<MonikerResponse, AnyJSONRPCResponseError>
	func semanticTokensFull(id: JSONId, params: SemanticTokensParams) async -> Result<SemanticTokensResponse, AnyJSONRPCResponseError>
	func semanticTokensFullDelta(id: JSONId, params: SemanticTokensDeltaParams) async -> Result<SemanticTokensDeltaResponse, AnyJSONRPCResponseError>
	func semanticTokensRange(id: JSONId, params: SemanticTokensRangeParams) async -> Result<SemanticTokensResponse, AnyJSONRPCResponseError>
	func callHierarchyIncomingCalls(id: JSONId, params: CallHierarchyIncomingCallsParams) async -> Result<CallHierarchyIncomingCallsResponse, AnyJSONRPCResponseError>
	func callHierarchyOutgoingCalls(id: JSONId, params: CallHierarchyOutgoingCallsParams) async -> Result<CallHierarchyOutgoingCallsResponse, AnyJSONRPCResponseError>
	func custom(id: JSONId, method: String, params: LSPAny) async -> Result<LSPAny, AnyJSONRPCResponseError>
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

	func initialize(id: JSONId, params: InitializeParams) async -> Result<InitializationResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func shutdown(id: JSONId) async { }
	func workspaceInlayHintRefresh(id: JSONId) async { }
	func workspaceExecuteCommand(id: JSONId, params: ExecuteCommandParams) async -> Result<LSPAny?, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func workspaceWillCreateFiles(id: JSONId, params: CreateFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func workspaceWillRenameFiles(id: JSONId, params: RenameFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func workspaceWillDeleteFiles(id: JSONId, params: DeleteFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func workspaceSymbol(id: JSONId, params: WorkspaceSymbolParams) async -> Result<WorkspaceSymbolResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func workspaceSymbolResolve(id: JSONId, params: WorkspaceSymbol) async -> Result<WorkspaceSymbol, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func textDocumentWillSaveWaitUntil(id: JSONId, params: WillSaveTextDocumentParams) async -> Result<[TextEdit]?, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func completion(id: JSONId, params: CompletionParams) async -> Result<CompletionResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func completionItemResolve(id: JSONId, params: CompletionItem) async -> Result<CompletionItem, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func hover(id: JSONId, params: TextDocumentPositionParams) async -> Result<HoverResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func signatureHelp(id: JSONId, params: TextDocumentPositionParams) async -> Result<SignatureHelpResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func declaration(id: JSONId, params: TextDocumentPositionParams) async -> Result<DeclarationResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func definition(id: JSONId, params: TextDocumentPositionParams) async -> Result<DefinitionResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func typeDefinition(id: JSONId, params: TextDocumentPositionParams) async -> Result<TypeDefinitionResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func implementation(id: JSONId, params: TextDocumentPositionParams) async -> Result<ImplementationResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func diagnostics(id: JSONId, params: DocumentDiagnosticParams) async -> Result<DocumentDiagnosticReport, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func documentHighlight(id: JSONId, params: DocumentHighlightParams) async -> Result<DocumentHighlightResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func documentSymbol(id: JSONId, params: DocumentSymbolParams) async -> Result<DocumentSymbolResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func codeAction(id: JSONId, params: CodeActionParams) async -> Result<CodeActionResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func codeActionResolve(id: JSONId, params: CodeAction) async -> Result<CodeAction, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func codeLens(id: JSONId, params: CodeLensParams) async -> Result<CodeLensResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func codeLensResolve(id: JSONId, params: CodeLens) async -> Result<CodeLens, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func selectionRange(id: JSONId, params: SelectionRangeParams) async -> Result<SelectionRangeResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func linkedEditingRange(id: JSONId, params: LinkedEditingRangeParams) async -> Result<LinkedEditingRangeResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func prepareCallHierarchy(id: JSONId, params: CallHierarchyPrepareParams) async -> Result<CallHierarchyPrepareResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func prepareRename(id: JSONId, params: PrepareRenameParams) async -> Result<PrepareRenameResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func rename(id: JSONId, params: RenameParams) async -> Result<RenameResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func inlayHint(id: JSONId, params: InlayHintParams) async -> Result<InlayHintResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func inlayHintResolve(id: JSONId, params: InlayHint) async -> Result<InlayHintResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func documentLink(id: JSONId, params: DocumentLinkParams) async -> Result<DocumentLinkResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func documentLinkResolve(id: JSONId, params: DocumentLink) async -> Result<DocumentLink, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func documentColor(id: JSONId, params: DocumentColorParams) async -> Result<DocumentColorResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func colorPresentation(id: JSONId, params: ColorPresentationParams) async -> Result<ColorPresentationResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func formatting(id: JSONId, params: DocumentFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func rangeFormatting(id: JSONId, params: DocumentRangeFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func onTypeFormatting(id: JSONId, params: DocumentOnTypeFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func references(id: JSONId, params: ReferenceParams) async -> Result<ReferenceResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func foldingRange(id: JSONId, params: FoldingRangeParams) async -> Result<FoldingRangeResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func moniker(id: JSONId, params: MonkierParams) async -> Result<MonikerResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func semanticTokensFull(id: JSONId, params: SemanticTokensParams) async -> Result<SemanticTokensResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func semanticTokensFullDelta(id: JSONId, params: SemanticTokensDeltaParams) async -> Result<SemanticTokensDeltaResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func semanticTokensRange(id: JSONId, params: SemanticTokensRangeParams) async -> Result<SemanticTokensResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func callHierarchyIncomingCalls(id: JSONId, params: CallHierarchyIncomingCallsParams) async -> Result<CallHierarchyIncomingCallsResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func callHierarchyOutgoingCalls(id: JSONId, params: CallHierarchyOutgoingCallsParams) async -> Result<CallHierarchyOutgoingCallsResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
	func custom(id: JSONId, method: String, params: LSPAny) async -> Result<LSPAny, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
}
