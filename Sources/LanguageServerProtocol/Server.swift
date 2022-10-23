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
                completionHandler(nil)
            }
        }
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension Server {
    func sendNotification(_ notif: ClientNotification) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.sendNotification(notif) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    func sendRequest<Response: Codable>(_ request: ClientRequest) async throws -> Response {
        return try await withCheckedThrowingContinuation { continutation in
            self.sendRequest(request) { result in
                continutation.resume(with: result)
            }
        }
    }
}

public extension Server {
	@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
	func initialize(params: InitializeParams) async throws -> InitializationResponse {
		return try await withCheckedThrowingContinuation { continutation in
			self.initialize(params: params) { result in
				continutation.resume(with: result)
			}
		}
	}

    func initialize(params: InitializeParams, block: @escaping (ServerResult<InitializationResponse>) -> Void) {
        sendRequest(.initialize(params), completionHandler: block)
    }

    func initialized(params: InitializedParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.initialized(params), completionHandler: block)
    }

	@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
	func initialized(params: InitializedParams) async throws {
		try await withCheckedThrowingContinuation { (continutation: CheckedContinuation<Void, Error>) in
			self.initialized(params: params) { error in
				if let error = error {
					continutation.resume(throwing: error)
				} else {
					continutation.resume()
				}
			}
		}
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

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func didOpenTextDocument(params: DidOpenTextDocumentParams) async throws {
        try await withCheckedThrowingContinuation { (continutation: CheckedContinuation<Void, Error>) in
            self.didOpenTextDocument(params: params) { error in
                if let error = error {
                    continutation.resume(throwing: error)
                } else {
                    continutation.resume()
                }
            }
        }
    }

    func didChangeTextDocument(params: DidChangeTextDocumentParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.didChangeTextDocument(params), completionHandler: block)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func didChangeTextDocument(params: DidChangeTextDocumentParams) async throws {
        try await withCheckedThrowingContinuation { (continutation: CheckedContinuation<Void, Error>) in
            self.didChangeTextDocument(params: params) { error in
                if let error = error {
                    continutation.resume(throwing: error)
                } else {
                    continutation.resume()
                }
            }
        }
    }

    func didCloseTextDocument(params: DidCloseTextDocumentParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.didCloseTextDocument(params), completionHandler: block)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func didCloseTextDocument(params: DidCloseTextDocumentParams) async throws {
        try await withCheckedThrowingContinuation { (continutation: CheckedContinuation<Void, Error>) in
            self.didCloseTextDocument(params: params) { error in
                if let error = error {
                    continutation.resume(throwing: error)
                } else {
                    continutation.resume()
                }
            }
        }
    }

    func willSaveTextDocument(params: WillSaveTextDocumentParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.willSaveTextDocument(params), completionHandler: block)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func willSaveTextDocument(params: WillSaveTextDocumentParams) async throws {
        try await withCheckedThrowingContinuation { (continutation: CheckedContinuation<Void, Error>) in
            self.willSaveTextDocument(params: params) { error in
                if let error = error {
                    continutation.resume(throwing: error)
                } else {
                    continutation.resume()
                }
            }
        }
    }

    func willSaveWaitUntilTextDocument(params: WillSaveTextDocumentParams, block: @escaping (ServerResult<WillSaveWaitUntilResponse>) -> Void) {
        sendRequest(.willSaveWaitUntilTextDocument(params), completionHandler: block)
    }

    func didSaveTextDocument(params: DidSaveTextDocumentParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.didSaveTextDocument(params), completionHandler: block)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func didSaveTextDocument(params: DidSaveTextDocumentParams) async throws {
        try await withCheckedThrowingContinuation { (continutation: CheckedContinuation<Void, Error>) in
            self.didSaveTextDocument(params: params) { error in
                if let error = error {
                    continutation.resume(throwing: error)
                } else {
                    continutation.resume()
                }
            }
        }
    }

    func didChangeWatchedFiles(params: DidChangeWatchedFilesParams, block: @escaping (ServerError?) -> Void) {
        sendNotification(.didChangeWatchedFiles(params), completionHandler: block)
    }

	@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
	func didChangeWatchedFiles(params: DidChangeWatchedFilesParams) async throws {
		try await withCheckedThrowingContinuation { (continutation: CheckedContinuation<Void, Error>) in
			self.didChangeWatchedFiles(params: params) { error in
				if let error = error {
					continutation.resume(throwing: error)
				} else {
					continutation.resume()
				}
			}
		}
	}

    func completion(params: CompletionParams, block: @escaping (ServerResult<CompletionResponse>) -> Void) {
        sendRequest(.completion(params), completionHandler: block)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func completion(params: CompletionParams) async throws -> CompletionResponse {
        try await withCheckedThrowingContinuation { continutation in
            self.completion(params: params) { result in
                continutation.resume(with: result)
            }
        }
    }

    func hover(params: TextDocumentPositionParams, block: @escaping (ServerResult<HoverResponse>) -> Void) {
        sendRequest(.hover(params), completionHandler: block)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func hover(params: TextDocumentPositionParams) async throws -> HoverResponse {
        try await withCheckedThrowingContinuation { continutation in
            self.hover(params: params) { result in
                continutation.resume(with: result)
            }
        }
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

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func definition(params: TextDocumentPositionParams) async throws -> DefinitionResponse {
        try await withCheckedThrowingContinuation { continutation in
            self.definition(params: params) { result in
                continutation.resume(with: result)
            }
        }
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

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func codeAction(params: CodeActionParams) async throws -> CodeActionResponse {
        try await withCheckedThrowingContinuation { continutation in
            codeAction(params: params) { result in
                continutation.resume(with: result)
            }
        }
    }

	func prepareCallHeirarchy(params: CallHierarchyPrepareParams, block: @escaping (ServerResult<PrepareRenameResponse>) -> Void) {
		sendRequest(.prepareCallHeirarchy(params), completionHandler: block)
	}

	@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
	func prepareCallHeirarchy(params: CallHierarchyPrepareParams) async throws -> PrepareRenameResponse {
		try await withCheckedThrowingContinuation { continutation in
			prepareCallHeirarchy(params: params) { result in
				continutation.resume(with: result)
			}
		}
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

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func formatting(params: DocumentFormattingParams) async throws -> FormattingResult {
        try await withCheckedThrowingContinuation { continutation in
            self.formatting(params: params) { result in
                continutation.resume(with: result)
            }
        }
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

    func semanticTokensFull(params: SemanticTokensParams, block: @escaping (ServerResult<SemanticTokensResponse>) -> Void) {
        sendRequest(.semanticTokensFull(params), completionHandler: block)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func semanticTokensFull(params: SemanticTokensParams) async throws -> SemanticTokensResponse {
        try await withCheckedThrowingContinuation { continutation in
            self.semanticTokensFull(params: params) { result in
                continutation.resume(with: result)
            }
        }
    }

    func semanticTokensFullDelta(params: SemanticTokensDeltaParams, block: @escaping (ServerResult<SemanticTokensDeltaResponse>) -> Void) {
        sendRequest(.semanticTokensFullDelta(params), completionHandler: block)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func semanticTokensFullDelta(params: SemanticTokensDeltaParams) async throws -> SemanticTokensDeltaResponse {
        try await withCheckedThrowingContinuation { continutation in
            self.semanticTokensFullDelta(params: params) { result in
                continutation.resume(with: result)
            }
        }
    }

    func semanticTokensRange(params: SemanticTokensRangeParams, block: @escaping (ServerResult<SemanticTokensResponse>) -> Void) {
        sendRequest(.semanticTokensRange(params), completionHandler: block)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func semanticTokensRange(params: SemanticTokensRangeParams) async throws -> SemanticTokensResponse {
        try await withCheckedThrowingContinuation { continutation in
            self.semanticTokensRange(params: params) { result in
                continutation.resume(with: result)
            }
        }
    }

    func customRequest<Response: Codable>(method: String, params: AnyCodable, block: @escaping (ServerResult<Response>) -> Void) {
        sendRequest(.custom(method, params), completionHandler: block)
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

    func workspaceSymbol(params: WorkspaceSymbolParams, block: @escaping (ServerResult<WorkspaceSymbolResponse>) -> Void) {
        sendRequest(.workspaceSymbol(params), completionHandler: block)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func workspaceSymbol(params: WorkspaceSymbolParams) async throws -> WorkspaceSymbolResponse {
        try await withCheckedThrowingContinuation { continutation in
            self.workspaceSymbol(params: params) { result in
                continutation.resume(with: result)
            }
        }
    }


    func workspaceSymbolResolve(params: WorkspaceSymbol, block: @escaping (ServerResult<WorkspaceSymbolResponse>) -> Void) {
        sendRequest(.workspaceSymbolResolve(params), completionHandler: block)
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
