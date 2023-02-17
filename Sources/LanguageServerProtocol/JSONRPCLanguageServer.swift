import Foundation
import JSONRPC

public class JSONRPCLanguageServer: Server {
    typealias ProtocolResponse<T: Codable> = ProtocolTransport.ResponseResult<T>

    private let protocolTransport: ProtocolTransport

	public var requestHandler: RequestHandler?
	public var notificationHandler: NotificationHandler?

    public init(protocolTransport: ProtocolTransport) {
        self.protocolTransport = protocolTransport

        // These can be racy, where some data comes in just after deallocation. Happens during shutdown most
        // commonly. Making these weak, along with unsetting then in deinit should be safe.
		let requestHandler: ProtocolTransport.Handlers.RequestHandler = { [weak self] in
			self?.handleRequest($0, data: $1, callback: $2)
		}

		let notificationHandler: ProtocolTransport.Handlers.NotificationHandler = { [weak self] in
			self?.handleNotification($0, data: $1, block: $2)
		}

		let errorHandler: ProtocolTransport.Handlers.ErrorHandler = { error in
            // We're intentionally doing nothing here but logging because
            // there's a reasonable expectation that future interactions might
            // succeed.
            //
            // We leave it to higher-level implemenations to Do The Right Thing
            // with failures
            print("protocol level error: \(error.localizedDescription)")
        }

		protocolTransport.setHandlers(.init(request: requestHandler,
											notification: notificationHandler,
											error: errorHandler))
    }

    public convenience init(dataTransport: DataTransport)  {
        let framing = SeperatedHTTPHeaderMessageFraming()
        let messageTransport = MessageTransport(dataTransport: dataTransport, messageProtocol: framing)

        self.init(protocolTransport: ProtocolTransport(dataTransport: messageTransport))
    }

    deinit {
		protocolTransport.setHandlers(.init(request: nil, notification: nil, error: nil))
    }
    
    public var logMessages: Bool {
        get { return protocolTransport.logMessages }
        set { protocolTransport.logMessages = newValue }
    }

	public func setHandlers(_ handlers: ServerHandlers, completionHandler: @escaping (ServerError?) -> Void) {
		self.notificationHandler = handlers.notificationHandler
		self.requestHandler = handlers.requestHandler

		completionHandler(nil)
	}
}

extension JSONRPCLanguageServer {
    private func decodeNotificationParams<T: Codable>(data: Data) -> ServerResult<T> {
        do {
            let resultType = JSONRPCNotification<T>.self
            let result = try JSONDecoder().decode(resultType, from: data)

            switch result.params {
            case nil:
                return .failure(.missingExpectedParameter)
            case let params?:
                return .success(params)
            }
        } catch {
            return .failure(.unableToDecodeRequest(error))
        }
    }

    private func relayNotification<T: Codable>(data: Data, block: (T) -> Void) throws {
        let result: ServerResult<T> = decodeNotificationParams(data: data)

        block(try result.get())
    }

    private func handleNotification(_ anyNotification: AnyJSONRPCNotification, data: Data, block: @escaping (Error?) -> Void) {
        let methodName = anyNotification.method

        guard let method = ServerNotification.Method(rawValue: methodName) else {
            block(ServerError.unhandledMethod(methodName))
            return
        }

		guard let handler = notificationHandler else {
            block(ServerError.handlerUnavailable(methodName))
            return
        }

        do {
            switch method {
            case .windowLogMessage:
                try relayNotification(data: data) { (params: LogMessageParams) in
					handler(.windowLogMessage(params), block)
                }
            case .windowShowMessage:
                try relayNotification(data: data) { (params: ShowMessageParams) in
                    handler(.windowShowMessage(params), block)
                }
            case .textDocumentPublishDiagnostics:
                try relayNotification(data: data) { (params: PublishDiagnosticsParams) in
                    handler(.textDocumentPublishDiagnostics(params), block)
                }
            case .telemetryEvent:
                try relayNotification(data: data) { (params: LSPAny) in
                    handler(.telemetryEvent(params), block)
                }
            case .protocolCancelRequest:
                try relayNotification(data: data) { (params: CancelParams) in
                    handler(.protocolCancelRequest(params), block)
                }
            case .protocolProgress:
                try relayNotification(data: data) { (params: ProgressParams) in
                    handler(.protocolProgress(params), block)
                }
            case .protocolLogTrace:
                try relayNotification(data: data) { (params: LogTraceParams) in
                    handler(.protocolLogTrace(params), block)
                }
            }
        } catch {
            block(error)
        }
    }

    public func sendNotification(_ notif: ClientNotification, completionHandler: @escaping (ServerError?) -> Void) {
        let method = notif.method.rawValue

        switch notif {
        case .initialized(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .exit:
            let params: String? = nil // stand-in for null

            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .textDocumentDidChange(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .didOpenTextDocument(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .didChangeTextDocument(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .didCloseTextDocument(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .willSaveTextDocument(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .didSaveTextDocument(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .didChangeWatchedFiles(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .protocolCancelRequest(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .protocolSetTrace(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .workspaceDidChangeWorkspaceFolders(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .workspaceDidChangeConfiguration(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .workspaceDidCreateFiles(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .workspaceDidRenameFiles(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        case .workspaceDidDeleteFiles(let params):
            protocolTransport.sendNotification(params, method: method) { error in
                completionHandler(error.map({ .unableToSendNotification($0) }))
            }
        }
    }
}

extension JSONRPCLanguageServer {
    private func decodeRequest<T: Codable>(data: Data) -> Result<JSONRPCRequest<T>, ServerError> {
        let resultType = JSONRPCRequest<T>.self

        do {
            let result = try JSONDecoder().decode(resultType, from: data)

            return .success(result)
        } catch {
            return .failure(.unableToDecodeRequest(error))
        }
    }

    private func decodeRequestWithParams<Params: Codable>(data: Data) -> Result<Params, ServerError> {
        let requestResult: Result<JSONRPCRequest<Params>, ServerError> = self.decodeRequest(data: data)

        return requestResult.flatMap({ $0.getParamsResult() })
    }

    private func relayRequest(request: Result<ServerRequest, ServerError>, id: JSONId, block: @escaping (Result<AnyJSONRPCResponse, ServerError>) -> Void) {
		switch (request, requestHandler) {
        case (.failure, nil):
            block(.failure(.handlerUnavailable("unknown")))
        case (.success(let request), nil):
            block(.failure(.handlerUnavailable(request.method.rawValue)))
        case (.failure(let error), .some):
            block(.failure(error))
        case (.success(let request), let handler?):
            handler(request, { result in
                let mappedResult = result.map { anyCodable in
                    AnyJSONRPCResponse(id: id, result: anyCodable)
                }

                block(mappedResult)
            })
        }
    }

    private func handleRequestResult(_ anyRequest: AnyJSONRPCRequest, data: Data, block: @escaping (Result<AnyJSONRPCResponse, ServerError>) -> Void) {
        guard let method = ServerRequest.Method(rawValue: anyRequest.method) else {
            block(.failure(ServerError.unhandledMethod(anyRequest.method)))
            return
        }

        let id = anyRequest.id

        switch method {
        case .workspaceConfiguration:
            let requestResult: ServerResult<ConfigurationParams> = self.decodeRequestWithParams(data: data)
            let request = requestResult.map { ServerRequest.workspaceConfiguration($0) }

            relayRequest(request: request, id: id, block: block)
        case .workspaceFolders:
            let requestResult: ServerResult<UnusedParam> = self.decodeRequestWithParams(data: data)
            let request = requestResult.map { _ in ServerRequest.workspaceFolders }

            relayRequest(request: request, id: id, block: block)
        case .workspaceApplyEdit:
            let requestResult: ServerResult<ApplyWorkspaceEditParams> = self.decodeRequestWithParams(data: data)
            let request = requestResult.map { ServerRequest.workspaceApplyEdit($0) }

            relayRequest(request: request, id: id, block: block)
        case .clientRegisterCapability:
            let requestResult: ServerResult<RegistrationParams> = self.decodeRequestWithParams(data: data)
            let request = requestResult.map { ServerRequest.clientRegisterCapability($0) }

            relayRequest(request: request, id: id, block: block)
        case .clientUnregisterCapability:
            let requestResult: ServerResult<UnregistrationParams> = self.decodeRequestWithParams(data: data)
            let request = requestResult.map { ServerRequest.clientUnregisterCapability($0) }

            relayRequest(request: request, id: id, block: block)
        case .workspaceCodeLensRefresh:
            let requestResult: ServerResult<UnusedParam> = self.decodeRequestWithParams(data: data)
            let request = requestResult.map { _ in ServerRequest.workspaceFolders }

            relayRequest(request: request, id: id, block: block)
        case .workspaceSemanticTokenRefresh:
            let requestResult: ServerResult<UnusedParam> = self.decodeRequestWithParams(data: data)
            let request = requestResult.map { _ in ServerRequest.workspaceSemanticTokenRefresh }

            relayRequest(request: request, id: id, block: block)
        case .windowShowMessageRequest:
            let requestResult: ServerResult<ShowMessageRequestParams> = self.decodeRequestWithParams(data: data)
            let request = requestResult.map { ServerRequest.windowShowMessageRequest($0) }

            relayRequest(request: request, id: id, block: block)
        case .windowShowDocument:
            let requestResult: ServerResult<ShowDocumentParams> = self.decodeRequestWithParams(data: data)
            let request = requestResult.map { ServerRequest.windowShowDocument($0) }

            relayRequest(request: request, id: id, block: block)
        case .windowWorkDoneProgressCreate:
            let requestResult: ServerResult<WorkDoneProgressCreateParams> = self.decodeRequestWithParams(data: data)
            let request = requestResult.map { ServerRequest.windowWorkDoneProgressCreate($0) }

            relayRequest(request: request, id: id, block: block)
        case .windowWorkDoneProgressCancel:
            let requestResult: ServerResult<WorkDoneProgressCancelParams> = self.decodeRequestWithParams(data: data)
            let request = requestResult.map { ServerRequest.windowWorkDoneProgressCancel($0) }

            relayRequest(request: request, id: id, block: block)
        }
    }

    private func handleRequest(_ request: AnyJSONRPCRequest, data: Data, callback: @escaping (AnyJSONRPCResponse) -> Void) {
        handleRequestResult(request, data: data) { result in
            switch result {
            case .failure(let error):
                callback(request.response(with: error))
            case .success(let response):
                callback(response)
            }
        }
    }
}

extension JSONRPCLanguageServer {
    private func sendRequestWithHandler<Params: Codable, Response: Codable>(_ params: Params, method: String, handler: @escaping (ServerResult<Response>) -> Void) {
        protocolTransport.sendRequest(params, method: method) { (result: ProtocolResponse<Response>) in
            let newResult = result
                .mapError { ServerError.unableToSendRequest($0) }
                .flatMap {  $0.getServerResult() }

            handler(newResult)
        }
    }

    public func sendRequest<Response: Codable>(_ request: ClientRequest, completionHandler: @escaping (ServerResult<Response>) -> Void) {
        let method = request.method.rawValue

        switch request {
        case .initialize(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .shutdown:
            sendRequestWithHandler(UnusedParam(nil), method: method, handler: completionHandler)
        case .willSaveWaitUntilTextDocument(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .workspaceWillRenameFiles(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .completion(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .completionItemResolve(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .hover(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .signatureHelp(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .declaration(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .definition(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .typeDefinition(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .implementation(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .documentHighlight(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .documentSymbol(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .codeAction(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .codeLens(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .codeLensResolve(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
		case .prepareCallHierarchy(let params):
			sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .prepareRename(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .documentLink(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .documentLinkResolve(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .documentColor(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .colorPresentation(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .rename(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .formatting(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .rangeFormatting(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .onTypeFormatting(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .references(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .foldingRange(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .selectionRange(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .semanticTokensFull(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .semanticTokensFullDelta(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .semanticTokensRange(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .workspaceExecuteCommand(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .workspaceWillCreateFiles(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .workspaceWillDeleteFiles(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
		case .callHierarchyIncomingCalls(let params):
			sendRequestWithHandler(params, method: method, handler: completionHandler)
		case .callHierarchyOutgoingCalls(let params):
			sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .custom(let method, let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .workspaceSymbol(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        case .workspaceSymbolResolve(let params):
            sendRequestWithHandler(params, method: method, handler: completionHandler)
        }
    }
}
