import Foundation
import JSONRPC
import LanguageServerProtocol


public protocol RequestHandler : ProtocolHandler {
  typealias Handler = ClientRequest.Handler;

  func initialize(_ params: InitializeParams) async -> Result<InitializationResponse, AnyJSONRPCResponseError>
  func shutdown() async
  func workspaceExecuteCommand(_ params: ExecuteCommandParams) async -> Result<LSPAny?, AnyJSONRPCResponseError>
  func workspaceWillCreateFiles(_ params: CreateFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError>
  func workspaceWillRenameFiles(_ params: RenameFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError>
  func workspaceWillDeleteFiles(_ params: DeleteFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError>
  func workspaceSymbol(_ params: WorkspaceSymbolParams) async -> Result<WorkspaceSymbolResponse, AnyJSONRPCResponseError>
  func workspaceSymbolResolve(_ params: WorkspaceSymbol) async -> Result<WorkspaceSymbol, AnyJSONRPCResponseError>
  func textDocumentWillSaveWaitUntil(_ params: TextDocumentWillSaveParams) async -> Result<[TextEdit]?, AnyJSONRPCResponseError>
  func completion(_ params: CompletionParams) async -> Result<CompletionResponse, AnyJSONRPCResponseError>
  func completionItemResolve(_ params: CompletionItem) async -> Result<CompletionItem, AnyJSONRPCResponseError>
  func hover(_ params: TextDocumentPositionParams) async -> Result<HoverResponse, AnyJSONRPCResponseError>
  func signatureHelp(_ params: TextDocumentPositionParams) async -> Result<SignatureHelpResponse, AnyJSONRPCResponseError>
  func declaration(_ params: TextDocumentPositionParams) async -> Result<DeclarationResponse, AnyJSONRPCResponseError>
  func definition(_ params: TextDocumentPositionParams) async -> Result<DefinitionResponse, AnyJSONRPCResponseError>
  func typeDefinition(_ params: TextDocumentPositionParams) async -> Result<TypeDefinitionResponse, AnyJSONRPCResponseError>
  func implementation(_ params: TextDocumentPositionParams) async -> Result<ImplementationResponse, AnyJSONRPCResponseError>
  func diagnostics(_ params: DocumentDiagnosticParams) async -> Result<DocumentDiagnosticReport, AnyJSONRPCResponseError>
  func documentHighlight(_ params: DocumentHighlightParams) async -> Result<DocumentHighlightResponse, AnyJSONRPCResponseError>
  func documentSymbol(_ params: DocumentSymbolParams) async -> Result<DocumentSymbolResponse, AnyJSONRPCResponseError>
  func codeAction(_ params: CodeActionParams) async -> Result<CodeActionResponse, AnyJSONRPCResponseError>
  func codeActionResolve(_ params: CodeAction) async -> Result<CodeAction, AnyJSONRPCResponseError>
  func codeLens(_ params: CodeLensParams) async -> Result<CodeLensResponse, AnyJSONRPCResponseError>
  func codeLensResolve(_ params: CodeLens) async -> Result<CodeLens, AnyJSONRPCResponseError>
  func selectionRange(_ params: SelectionRangeParams) async -> Result<SelectionRangeResponse, AnyJSONRPCResponseError>
  func linkedEditingRange(_ params: LinkedEditingRangeParams) async -> Result<LinkedEditingRangeResponse, AnyJSONRPCResponseError>
  func prepareCallHierarchy(_ params: CallHierarchyPrepareParams) async -> Result<CallHierarchyPrepareResponse, AnyJSONRPCResponseError>
  func prepareRename(_ params: PrepareRenameParams) async -> Result<PrepareRenameResponse, AnyJSONRPCResponseError>
  func rename(_ params: RenameParams) async -> Result<RenameResponse, AnyJSONRPCResponseError>
  func documentLink(_ params: DocumentLinkParams) async -> Result<DocumentLinkResponse, AnyJSONRPCResponseError>
  func documentLinkResolve(_ params: DocumentLink) async -> Result<DocumentLink, AnyJSONRPCResponseError>
  func documentColor(_ params: DocumentColorParams) async -> Result<DocumentColorResponse, AnyJSONRPCResponseError>
  func colorPresentation(_ params: ColorPresentationParams) async -> Result<ColorPresentationResponse, AnyJSONRPCResponseError>
  func formatting(_ params: DocumentFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError>
  func rangeFormatting(_ params: DocumentRangeFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError>
  func onTypeFormatting(_ params: DocumentOnTypeFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError>
  func references(_ params: ReferenceParams) async -> Result<ReferenceResponse, AnyJSONRPCResponseError>
  func foldingRange(_ params: FoldingRangeParams) async -> Result<FoldingRangeResponse, AnyJSONRPCResponseError>
  func moniker(_ params: MonkierParams) async -> Result<MonikerResponse, AnyJSONRPCResponseError>
  func semanticTokensFull(_ params: SemanticTokensParams) async -> Result<SemanticTokensResponse, AnyJSONRPCResponseError>
  func semanticTokensFullDelta(_ params: SemanticTokensDeltaParams) async -> Result<SemanticTokensDeltaResponse, AnyJSONRPCResponseError>
  func semanticTokensRange(_ params: SemanticTokensRangeParams) async -> Result<SemanticTokensResponse, AnyJSONRPCResponseError>
  func callHierarchyIncomingCalls(_ params: CallHierarchyIncomingCallsParams) async -> Result<CallHierarchyIncomingCallsResponse, AnyJSONRPCResponseError>
  func callHierarchyOutgoingCalls(_ params: CallHierarchyOutgoingCallsParams) async -> Result<CallHierarchyOutgoingCallsResponse, AnyJSONRPCResponseError>
  func custom(_ method: String, _ params: LSPAny) async -> Result<LSPAny, AnyJSONRPCResponseError>
}

public extension RequestHandler {
  func handleRequest(_ request: ClientRequest) async {

    switch request {
    case let .initialize(params, handler):
      await handler(await initialize(params))
    case .shutdown:
      await shutdown()
    case let .workspaceExecuteCommand(params, handler):
      await handler(await workspaceExecuteCommand(params))
    case let .workspaceWillCreateFiles(params, handler):
      await handler(await workspaceWillCreateFiles(params))
    case let .workspaceWillRenameFiles(params, handler):
      await handler(await workspaceWillRenameFiles(params))
    case let .workspaceWillDeleteFiles(params, handler):
      await handler(await workspaceWillDeleteFiles(params))
    case let .workspaceSymbol(params, handler):
      await handler(await workspaceSymbol(params))
    case let .workspaceSymbolResolve(params, handler):
      await handler(await workspaceSymbolResolve(params))
    case let .textDocumentWillSaveWaitUntil(params, handler):
      await handler(await textDocumentWillSaveWaitUntil(params))
    case let .completion(params, handler):
      await handler(await completion(params))
    case let .completionItemResolve(params, handler):
      await handler(await completionItemResolve(params))
    case let .hover(params, handler):
      await handler(await hover(params))
    case let .signatureHelp(params, handler):
      await handler(await signatureHelp(params))
    case let .declaration(params, handler):
      await handler(await declaration(params))
    case let .definition(params, handler):
      await handler(await definition(params))
    case let .typeDefinition(params, handler):
      await handler(await typeDefinition(params))
    case let .implementation(params, handler):
      await handler(await implementation(params))
    case let .diagnostics(params, handler):
      await handler(await diagnostics(params))
    case let .documentHighlight(params, handler):
      await handler(await documentHighlight(params))
    case let .documentSymbol(params, handler):
      await handler(await documentSymbol(params))
    case let .codeAction(params, handler):
      await handler(await codeAction(params))
    case let .codeActionResolve(params, handler):
      await handler(await codeActionResolve(params))
    case let .codeLens(params, handler):
      await handler(await codeLens(params))
    case let .codeLensResolve(params, handler):
      await handler(await codeLensResolve(params))
    case let .selectionRange(params, handler):
      await handler(await selectionRange(params))
    case let .linkedEditingRange(params, handler):
      await handler(await linkedEditingRange(params))
    case let .prepareCallHierarchy(params, handler):
      await handler(await prepareCallHierarchy(params))
    case let .prepareRename(params, handler):
      await handler(await prepareRename(params))
    case let .rename(params, handler):
      await handler(await rename(params))
    case let .documentLink(params, handler):
      await handler(await documentLink(params))
    case let .documentLinkResolve(params, handler):
      await handler(await documentLinkResolve(params))
    case let .documentColor(params, handler):
      await handler(await documentColor(params))
    case let .colorPresentation(params, handler):
      await handler(await colorPresentation(params))
    case let .formatting(params, handler):
      await handler(await formatting(params))
    case let .rangeFormatting(params, handler):
      await handler(await rangeFormatting(params))
    case let .onTypeFormatting(params, handler):
      await handler(await onTypeFormatting(params))
    case let .references(params, handler):
      await handler(await references(params))
    case let .foldingRange(params, handler):
      await handler(await foldingRange(params))
    case let .moniker(params, handler):
      await handler(await moniker(params))
    case let .semanticTokensFull(params, handler):
      await handler(await semanticTokensFull(params))
    case let .semanticTokensFullDelta(params, handler):
      await handler(await semanticTokensFullDelta(params))
    case let .semanticTokensRange(params, handler):
      await handler(await semanticTokensRange(params))
    case let .callHierarchyIncomingCalls(params, handler):
      await handler(await callHierarchyIncomingCalls(params))
    case let .callHierarchyOutgoingCalls(params, handler):
      await handler(await callHierarchyOutgoingCalls(params))
    case let .custom(method, params, handler):
      await handler(await custom(method, params))
    }
  }
}


let NotImplementedError = AnyJSONRPCResponseError(code: ErrorCodes.InternalError, message: "TODO")

/// Provide default implementations for all protocol methods
/// We do this since the handler only need to support a subset, based on dynamically registered capabilities
public extension RequestHandler {

  func initialize(_ params: InitializeParams) async -> Result<InitializationResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func shutdown() async { }
  func workspaceExecuteCommand(_ params: ExecuteCommandParams) async -> Result<LSPAny?, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func workspaceWillCreateFiles(_ params: CreateFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func workspaceWillRenameFiles(_ params: RenameFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func workspaceWillDeleteFiles(_ params: DeleteFilesParams) async -> Result<WorkspaceEdit?, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func workspaceSymbol(_ params: WorkspaceSymbolParams) async -> Result<WorkspaceSymbolResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func workspaceSymbolResolve(_ params: WorkspaceSymbol) async -> Result<WorkspaceSymbol, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func textDocumentWillSaveWaitUntil(_ params: TextDocumentWillSaveParams) async -> Result<[TextEdit]?, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func completion(_ params: CompletionParams) async -> Result<CompletionResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func completionItemResolve(_ params: CompletionItem) async -> Result<CompletionItem, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func hover(_ params: TextDocumentPositionParams) async -> Result<HoverResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func signatureHelp(_ params: TextDocumentPositionParams) async -> Result<SignatureHelpResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func declaration(_ params: TextDocumentPositionParams) async -> Result<DeclarationResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func definition(_ params: TextDocumentPositionParams) async -> Result<DefinitionResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func typeDefinition(_ params: TextDocumentPositionParams) async -> Result<TypeDefinitionResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func implementation(_ params: TextDocumentPositionParams) async -> Result<ImplementationResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func diagnostics(_ params: DocumentDiagnosticParams) async -> Result<DocumentDiagnosticReport, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func documentHighlight(_ params: DocumentHighlightParams) async -> Result<DocumentHighlightResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func documentSymbol(_ params: DocumentSymbolParams) async -> Result<DocumentSymbolResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func codeAction(_ params: CodeActionParams) async -> Result<CodeActionResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func codeActionResolve(_ params: CodeAction) async -> Result<CodeAction, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func codeLens(_ params: CodeLensParams) async -> Result<CodeLensResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func codeLensResolve(_ params: CodeLens) async -> Result<CodeLens, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func selectionRange(_ params: SelectionRangeParams) async -> Result<SelectionRangeResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func linkedEditingRange(_ params: LinkedEditingRangeParams) async -> Result<LinkedEditingRangeResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func prepareCallHierarchy(_ params: CallHierarchyPrepareParams) async -> Result<CallHierarchyPrepareResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func prepareRename(_ params: PrepareRenameParams) async -> Result<PrepareRenameResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func rename(_ params: RenameParams) async -> Result<RenameResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func documentLink(_ params: DocumentLinkParams) async -> Result<DocumentLinkResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func documentLinkResolve(_ params: DocumentLink) async -> Result<DocumentLink, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func documentColor(_ params: DocumentColorParams) async -> Result<DocumentColorResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func colorPresentation(_ params: ColorPresentationParams) async -> Result<ColorPresentationResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func formatting(_ params: DocumentFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func rangeFormatting(_ params: DocumentRangeFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func onTypeFormatting(_ params: DocumentOnTypeFormattingParams) async -> Result<FormattingResult, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func references(_ params: ReferenceParams) async -> Result<ReferenceResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func foldingRange(_ params: FoldingRangeParams) async -> Result<FoldingRangeResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func moniker(_ params: MonkierParams) async -> Result<MonikerResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func semanticTokensFull(_ params: SemanticTokensParams) async -> Result<SemanticTokensResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func semanticTokensFullDelta(_ params: SemanticTokensDeltaParams) async -> Result<SemanticTokensDeltaResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func semanticTokensRange(_ params: SemanticTokensRangeParams) async -> Result<SemanticTokensResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func callHierarchyIncomingCalls(_ params: CallHierarchyIncomingCallsParams) async -> Result<CallHierarchyIncomingCallsResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func callHierarchyOutgoingCalls(_ params: CallHierarchyOutgoingCallsParams) async -> Result<CallHierarchyOutgoingCallsResponse, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
  func custom(_ method: String, _ params: LSPAny) async -> Result<LSPAny, AnyJSONRPCResponseError> { .failure(NotImplementedError) }
}
