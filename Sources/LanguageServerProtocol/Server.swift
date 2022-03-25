import Foundation
import JSONRPC
import AnyCodable

public enum ServerError: LocalizedError {
    case handlerUnavailable(String)
    case unhandledMethod(String)
    case notificationDispatchFailed(Error)
    case requestDispatchFailed(Error)
    case clientDataUnavailable(Error)
    case serverUnavailable
    case missingExpectedParameter
    case missingExpectedResult
    case unableToDecodeRequest(Error)
    case unableToSendRequest(Error)
    case unableToSendNotification(Error)
    case serverError(code: Int, message: String, data: Codable?)
    case invalidRequest(Error?)
    case timeout

    static func responseError(_ error: AnyJSONRPCResponseError) -> ServerError {
        return ServerError.serverError(code: error.code,
                                       message: error.message,
                                       data: error.data)
    }
}

public typealias ServerResult<T: Codable> = Result<T, ServerError>

public protocol Server {
    typealias RequestHandler = (ServerRequest, @escaping (ServerResult<AnyCodable>) -> Void) -> Void
    typealias NotificationHandler = (ServerNotification, @escaping (ServerError?) -> Void) -> Void
    typealias ResponseHandler<T: Codable> = (ServerResult<JSONRPCResponse<T>>) -> Void

    var requestHandler: RequestHandler? { get set }
    var notificationHandler: NotificationHandler? { get set }

    func sendNotification(_ notif: ClientNotification, completionHandler: @escaping (ServerError?) -> Void)
    func sendRequest<Response: Codable>(_ request: ClientRequest, completionHandler: @escaping (ServerResult<Response>) -> Void)
}

extension Server {
    func sendRequestWithErrorOnlyResult(_ request: ClientRequest, completionHandler: @escaping (ServerError?) -> Void) {
        sendRequest(request) { (result: ServerResult<UnusedResult>) in
            switch result {
            case .failure(let error):
                completionHandler(error)
            case .success:
                break
            }

            completionHandler(nil)
        }
    }
}

public extension Server {
    func initialize(params: InitializeParams, block: @escaping (ServerResult<InitializationResponse>) -> Void) {
        sendRequest(.initialize(params), completionHandler: block)
    }

    func initialized(params: InitializedParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.initialized(params), completionHandler: block)
    }

    func shutdown(block: @escaping (ServerError?) -> Void) {
        sendRequestWithErrorOnlyResult(.shutdown, completionHandler: block)
    }

    func exit(block: @escaping (ServerError?) -> Void) {
        sendNotification(.exit, completionHandler: block)
    }

    func cancelRequest(params: CancelParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.protocolCancelRequest(params), completionHandler: block)
    }

    func setTrace(params: SetTraceParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.protocolSetTrace(params), completionHandler: block)
    }

    func didOpenTextDocument(params: DidOpenTextDocumentParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.didOpenTextDocument(params), completionHandler: block)
    }

    func didChangeTextDocument(params: DidChangeTextDocumentParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.didChangeTextDocument(params), completionHandler: block)
    }

    func didCloseTextDocument(params: DidCloseTextDocumentParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.didCloseTextDocument(params), completionHandler: block)
    }

    func willSaveTextDocument(params: WillSaveTextDocumentParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.willSaveTextDocument(params), completionHandler: block)
    }

    func willSaveWaitUntilTextDocument(params: WillSaveTextDocumentParams, block: @escaping (ServerResult<WillSaveWaitUntilResponse>) -> Void) {
        sendRequest(.willSaveWaitUntilTextDocument(params), completionHandler: block)
    }

    func didSaveTextDocument(params: DidSaveTextDocumentParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.didSaveTextDocument(params), completionHandler: block)
    }

    func didChangeWatchedFiles(params: DidChangeWatchedFilesParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.didChangeWatchedFiles(params), completionHandler: block)
    }

    func completion(params: CompletionParams, block: @escaping (ServerResult<CompletionResponse>) -> Void) {
        sendRequest(.completion(params), completionHandler: block)
    }

    func hover(params: TextDocumentPositionParams, block: @escaping (ServerResult<HoverResponse>) -> Void) {
        sendRequest(.hover(params), completionHandler: block)
    }

    func signatureHelp(params: TextDocumentPositionParams, block: @escaping (ServerResult<SignatureHelpResponse>) -> Void) {
        sendRequest(.signatureHelp(params), completionHandler: block)
    }

    func declaration(params: TextDocumentPositionParams, block: @escaping (ServerResult<DeclarationResponse>) -> Void) {
        sendRequest(.declaration(params), completionHandler: block)
    }

    func definition(params: TextDocumentPositionParams, block: @escaping (ServerResult<DefinitionResponse>) -> Void) {
        sendRequest(.definition(params), completionHandler: block)
    }

    func typeDefinition(params: TextDocumentPositionParams, block: @escaping (ServerResult<TypeDefinitionResponse>) -> Void) {
        sendRequest(.typeDefinition(params), completionHandler: block)
    }

    func implementation(params: TextDocumentPositionParams, block: @escaping (ServerResult<ImplementationResponse>) -> Void) {
        sendRequest(.implementation(params), completionHandler: block)
    }

    func documentSymbol(params: DocumentSymbolParams, block: @escaping (ServerResult<DocumentSymbolResponse>) -> Void) {
        sendRequest(.documentSymbol(params), completionHandler: block)
    }

    func codeAction(params: CodeActionParams, block: @escaping (ServerResult<CodeActionResponse>) -> Void) {
        sendRequest(.codeAction(params), completionHandler: block)
    }
    
    func prepareRename(params: PrepareRenameParams, block: @escaping (ServerResult<PrepareRenameResponse>) -> Void) {
        sendRequest(.prepareRename(params), completionHandler: block)
    }

    func rename(params: RenameParams, block: @escaping (ServerResult<RenameResponse>) -> Void) {
        sendRequest(.rename(params), completionHandler: block)
    }

    func formatting(params: DocumentFormattingParams, block: @escaping (ServerResult<FormattingResult>) -> Void) {
        sendRequest(.formatting(params), completionHandler: block)
    }

    func rangeFormatting(params: DocumentRangeFormattingParams, block: @escaping (ServerResult<FormattingResult>) -> Void) {
        sendRequest(.rangeFormatting(params), completionHandler: block)
    }

    func onTypeFormatting(params: DocumentOnTypeFormattingParams, block: @escaping (ServerResult<FormattingResult>) -> Void) {
        sendRequest(.onTypeFormatting(params), completionHandler: block)
    }

    func references(params: ReferenceParams, block: @escaping (ServerResult<ReferenceResponse>) -> Void) {
        sendRequest(.references(params), completionHandler: block)
    }

    func foldingRange(params: FoldingRangeParams, block: @escaping (ServerResult<FoldingRangeResponse>) -> Void) {
        sendRequest(.foldingRange(params), completionHandler: block)
    }

    func semanticTokensFull(params: SemanticTokensParams, block: @escaping (ServerResult<SemanticTokens?>) -> Void) {
        sendRequest(.semanticTokensFull(params), completionHandler: block)
    }

    func semanticTokensFullDelta(params: SemanticTokensDeltaParams, block: @escaping (ServerResult<SemanticTokensDeltaResponse?>) -> Void) {
        sendRequest(.semanticTokensFullDelta(params), completionHandler: block)
    }

    func semanticTokensRange(params: SemanticTokensRangeParams, block: @escaping (ServerResult<SemanticTokens>) -> Void) {
        sendRequest(.semanticTokensRange(params), completionHandler: block)
    }
}

// Workspace notifications
public extension Server {
    func didChangeWorkspaceFolders(params: DidChangeWorkspaceFoldersParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.workspaceDidChangeWorkspaceFolders(params), completionHandler: block)
    }

    func didChangeConfiguration(params: DidChangeConfigurationParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.workspaceDidChangeConfiguration(params), completionHandler: block)
    }

    func didCreateFiles(params: CreateFilesParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.workspaceDidCreateFiles(params), completionHandler: block)
    }

    func didRenameFiles(params: RenameFilesParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.workspaceDidRenameFiles(params), completionHandler: block)
    }

    func didDeleteFiles(params: DeleteFilesParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.workspaceDidDeleteFiles(params), completionHandler: block)
    }
}

// Workspace Requests
public extension Server {
    func willCreateFiles(params: CreateFilesParams, block: @escaping (ServerResult<WorkspaceWillCreateFilesResponse>) -> Void) {
        sendRequest(.workspaceWillCreateFiles(params), completionHandler: block)
    }

    func willRenameFiles(params: RenameFilesParams, block: @escaping (ServerResult<WorkspaceWillRenameFilesResponse>) -> Void) {
        sendRequest(.workspaceWillRenameFiles(params), completionHandler: block)
    }

    func willDeleteFiles(params: DeleteFilesParams, block: @escaping (ServerResult<WorkspaceWillDeleteFilesResponse>) -> Void) {
        sendRequest(.workspaceWillDeleteFiles(params), completionHandler: block)
    }

    func executeCommand(params: ExecuteCommandParams, block: @escaping (ServerResult<ExecuteCommandResponse>) -> Void) {
        sendRequest(.workspaceExecuteCommand(params), completionHandler: block)
    }
}

// Language Features
public extension Server {
    func documentHighlight(params: DocumentHighlightParams, block: @escaping (ServerResult<DocumentHighlightResponse>) -> Void) {
        sendRequest(.documentHighlight(params), completionHandler: block)
    }

    func codeLens(params: CodeLensParams, block: @escaping (ServerResult<CodeLensResponse>) -> Void) {
        sendRequest(.codeLens(params), completionHandler: block)
    }

    func codeLensResolve(params: CodeLens, block: @escaping (ServerResult<CodeLensResolveResponse>) -> Void) {
        sendRequest(.codeLensResolve(params), completionHandler: block)
    }

    func selectionRange(params: SelectionRangeParams, block: @escaping (ServerResult<SelectionRangeResponse>) -> Void) {
        sendRequest(.selectionRange(params), completionHandler: block)
    }

    func documentLink(params: DocumentLinkParams, block: @escaping (ServerResult<DocumentLinkResponse>) -> Void) {
        sendRequest(.documentLink(params), completionHandler: block)
    }

    func documentLinkResolve(params: DocumentLink, block: @escaping (ServerResult<DocumentLink>) -> Void) {
        sendRequest(.documentLinkResolve(params), completionHandler: block)
    }

    func documentColor(params: DocumentColorParams, block: @escaping (ServerResult<DocumentColorResponse>) -> Void) {
        sendRequest(.documentColor(params), completionHandler: block)
    }

    func colorPresentation(params: ColorPresentationParams, block: @escaping (ServerResult<ColorPresentationResponse>) -> Void) {
        sendRequest(.colorPresentation(params), completionHandler: block)
    }
}
