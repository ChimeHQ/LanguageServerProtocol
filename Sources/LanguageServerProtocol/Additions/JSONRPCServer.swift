import Foundation
import JSONRPC

enum ServerError: Error {
	case unrecognizedMethod(String)
	case missingParams
	case unhandledRegisterationMethod(String)
	case missingReply
}

public actor JSONRPCServer: Server {
	public let notificationSequence: NotificationSequence
	public let requestSequence: RequestSequence

	private let notificationContinuation: NotificationSequence.Continuation
	private let requestContinuation: RequestSequence.Continuation

	private let session: JSONRPCSession
	private var notificationTask: Task<Void, Never>?
	private var requestTask: Task<Void, Never>?

	public init(dataChannel: DataChannel) {
		self.session = JSONRPCSession(channel: dataChannel)
		
		(self.notificationSequence, self.notificationContinuation) = NotificationSequence.makeStream()
		(self.requestSequence, self.requestContinuation) = RequestSequence.makeStream()

		Task {
			await startMonitoringSession()
		}
	}

	deinit {
		notificationTask?.cancel()
		notificationContinuation.finish()

		requestTask?.cancel()
		requestContinuation.finish()
	}

	private func startMonitoringSession() async {
		let noteSequence = await session.notificationSequence

		self.notificationTask = Task { [weak self] in
			for await (notification, data) in noteSequence {
				guard let self = self else { break }

				await self.handleNotification(notification, data: data)
			}

			self?.notificationContinuation.finish()
		}

		let reqSequence = await session.requestSequence

		self.requestTask = Task { [weak self] in
			for await (request, handler, data) in reqSequence {
				guard let self = self else { break }

				await self.handleRequest(request, data: data, handler: handler)
			}

			self?.requestContinuation.finish()
		}
	}

	public func sendNotification(_ notif: ClientNotification) async throws {
		let method = notif.method.rawValue
		
		switch notif {
		case .initialized(let params):
			try await session.sendNotification(params, method: method)
		case .exit:
			try await session.sendNotification(method: method)
		case .textDocumentDidChange(let params):
			try await session.sendNotification(params, method: method)
		case .didOpenTextDocument(let params):
			try await session.sendNotification(params, method: method)
		case .didChangeTextDocument(let params):
			try await session.sendNotification(params, method: method)
		case .didCloseTextDocument(let params):
			try await session.sendNotification(params, method: method)
		case .willSaveTextDocument(let params):
			try await session.sendNotification(params, method: method)
		case .didSaveTextDocument(let params):
			try await session.sendNotification(params, method: method)
		case .didChangeWatchedFiles(let params):
			try await session.sendNotification(params, method: method)
		case .protocolCancelRequest(let params):
			try await session.sendNotification(params, method: method)
		case .protocolSetTrace(let params):
			try await session.sendNotification(params, method: method)
		case .workspaceDidChangeWorkspaceFolders(let params):
			try await session.sendNotification(params, method: method)
		case .workspaceDidChangeConfiguration(let params):
			try await session.sendNotification(params, method: method)
		case .workspaceDidCreateFiles(let params):
			try await session.sendNotification(params, method: method)
		case .workspaceDidRenameFiles(let params):
			try await session.sendNotification(params, method: method)
		case .workspaceDidDeleteFiles(let params):
			try await session.sendNotification(params, method: method)
		case .windowWorkDoneProgressCancel(let params):
			try await session.sendNotification(params, method: method)
		}
	}

	public func sendRequest<Response>(_ request: ClientRequest) async throws -> Response where Response : Decodable & Sendable {
		let method = request.method.rawValue

		switch request {
		case .initialize(let params):
			return try await session.response(to: method, params: params)
		case .shutdown:
			return try await session.response(to: method)
		case .workspaceExecuteCommand(let params):
			return try await session.response(to: method, params: params)
		case .workspaceWillCreateFiles(let params):
			return try await session.response(to: method, params: params)
		case .workspaceWillRenameFiles(let params):
			return try await session.response(to: method, params: params)
		case .workspaceWillDeleteFiles(let params):
			return try await session.response(to: method, params: params)
		case .workspaceSymbol(let params):
			return try await session.response(to: method, params: params)
		case .workspaceSymbolResolve(let params):
			return try await session.response(to: method, params: params)
		case .willSaveWaitUntilTextDocument(let params):
			return try await session.response(to: method, params: params)
		case .completion(let params):
			return try await session.response(to: method, params: params)
		case .completionItemResolve(let params):
			return try await session.response(to: method, params: params)
		case .hover(let params):
			return try await session.response(to: method, params: params)
		case .signatureHelp(let params):
			return try await session.response(to: method, params: params)
		case .declaration(let params):
			return try await session.response(to: method, params: params)
		case .definition(let params):
			return try await session.response(to: method, params: params)
		case .typeDefinition(let params):
			return try await session.response(to: method, params: params)
		case .implementation(let params):
			return try await session.response(to: method, params: params)
		case .documentHighlight(let params):
			return try await session.response(to: method, params: params)
		case .documentSymbol(let params):
			return try await session.response(to: method, params: params)
		case .codeAction(let params):
			return try await session.response(to: method, params: params)
		case .codeLens(let params):
			return try await session.response(to: method, params: params)
		case .codeLensResolve(let params):
			return try await session.response(to: method, params: params)
		case .selectionRange(let params):
			return try await session.response(to: method, params: params)
		case .prepareCallHierarchy(let params):
			return try await session.response(to: method, params: params)
		case .prepareRename(let params):
			return try await session.response(to: method, params: params)
		case .rename(let params):
			return try await session.response(to: method, params: params)
		case .documentLink(let params):
			return try await session.response(to: method, params: params)
		case .documentLinkResolve(let params):
			return try await session.response(to: method, params: params)
		case .documentColor(let params):
			return try await session.response(to: method, params: params)
		case .colorPresentation(let params):
			return try await session.response(to: method, params: params)
		case .formatting(let params):
			return try await session.response(to: method, params: params)
		case .rangeFormatting(let params):
			return try await session.response(to: method, params: params)
		case .onTypeFormatting(let params):
			return try await session.response(to: method, params: params)
		case .references(let params):
			return try await session.response(to: method, params: params)
		case .foldingRange(let params):
			return try await session.response(to: method, params: params)
		case .semanticTokensFull(let params):
			return try await session.response(to: method, params: params)
		case .semanticTokensFullDelta(let params):
			return try await session.response(to: method, params: params)
		case .semanticTokensRange(let params):
			return try await session.response(to: method, params: params)
		case .callHierarchyIncomingCalls(let params):
			return try await session.response(to: method, params: params)
		case .callHierarchyOutgoingCalls(let params):
			return try await session.response(to: method, params: params)
		case let .custom(method, params):
			return try await session.response(to: method, params: params)
		}
	}

	private func decodeNotificationParams<Params>(_ type: Params.Type, from data: Data) throws -> Params where Params : Decodable {
		let note = try JSONDecoder().decode(JSONRPCNotification<Params>.self, from: data)

		guard let params = note.params else {
			throw ServerError.missingParams
		}

		return params
	}

	private func handleNotification(_ anyNotification: AnyJSONRPCNotification, data: Data) {
		let methodName = anyNotification.method

		do {
			guard let method = ServerNotification.Method(rawValue: methodName) else {
				throw ServerError.unrecognizedMethod(methodName)
			}

			switch method {
			case .windowLogMessage:
				let params = try decodeNotificationParams(LogMessageParams.self, from: data)
				
				notificationContinuation.yield(.windowLogMessage(params))
			case .windowShowMessage:
				let params = try decodeNotificationParams(ShowMessageParams.self, from: data)

				notificationContinuation.yield(.windowShowMessage(params))
			case .textDocumentPublishDiagnostics:
				let params = try decodeNotificationParams(PublishDiagnosticsParams.self, from: data)

				notificationContinuation.yield(.textDocumentPublishDiagnostics(params))
			case .telemetryEvent:
				let params = anyNotification.params ?? .null

				notificationContinuation.yield(.telemetryEvent(params))
			case .protocolCancelRequest:
				let params = try decodeNotificationParams(CancelParams.self, from: data)

				notificationContinuation.yield(.protocolCancelRequest(params))
			case .protocolProgress:
				let params = try decodeNotificationParams(ProgressParams.self, from: data)

				notificationContinuation.yield(.protocolProgress(params))
			case .protocolLogTrace:
				let params = try decodeNotificationParams(LogTraceParams.self, from: data)

				notificationContinuation.yield(.protocolLogTrace(params))
			}
		} catch {
			// should we backchannel this to the client somehow?
			print("failed to relay notification: \(error)")
		}
	}

	private func decodeRequestParams<Params>(_ type: Params.Type, from data: Data) throws -> Params where Params : Decodable {
		let req = try JSONDecoder().decode(JSONRPCRequest<Params>.self, from: data)

		guard let params = req.params else {
			throw ServerError.missingParams
		}

		return params
	}

	private nonisolated func makeErrorOnlyHandler(_ handler: @escaping JSONRPCSession.RequestHandler) -> ServerRequest.ErrorOnlyHandler {
		return {
			if let error = $0 {
				await handler(.failure(error))
			} else {
				await handler(.success(JSONValue.null))
			}
		}
	}

	private nonisolated func makeHandler<T>(_ handler: @escaping JSONRPCSession.RequestHandler) -> ServerRequest.Handler<T> {
		return {
			let loweredResult = $0.map({ $0 as Encodable & Sendable })

			await handler(loweredResult)
		}
	}

	private func handleRequest(_ anyRequest: AnyJSONRPCRequest, data: Data, handler: @escaping JSONRPCSession.RequestHandler) {
		let methodName = anyRequest.method

		do {
			guard let method = ServerRequest.Method(rawValue: methodName) else {
				throw ServerError.unrecognizedMethod(methodName)
			}

			switch method {
			case .workspaceConfiguration:
				let params = try decodeRequestParams(ConfigurationParams.self, from: data)
				let reqHandler: ServerRequest.Handler<[LSPAny]> = makeHandler(handler)

				requestContinuation.yield(ServerRequest.workspaceConfiguration(params, reqHandler))
			case .workspaceFolders:
				let reqHandler: ServerRequest.Handler<WorkspaceFoldersResponse> = makeHandler(handler)

				requestContinuation.yield(ServerRequest.workspaceFolders(reqHandler))
			case .workspaceApplyEdit:
				let params = try decodeRequestParams(ApplyWorkspaceEditParams.self, from: data)
				let reqHandler: ServerRequest.Handler<ApplyWorkspaceEditResult> = makeHandler(handler)

				requestContinuation.yield(ServerRequest.workspaceApplyEdit(params, reqHandler))
			case .clientRegisterCapability:
				let params = try decodeRequestParams(RegistrationParams.self, from: data)
				let reqHandler = makeErrorOnlyHandler(handler)

				requestContinuation.yield(ServerRequest.clientRegisterCapability(params, reqHandler))
			case .clientUnregisterCapability:
				let params = try decodeRequestParams(UnregistrationParams.self, from: data)
				let reqHandler = makeErrorOnlyHandler(handler)

				requestContinuation.yield(ServerRequest.clientUnregisterCapability(params, reqHandler))
			case .workspaceCodeLensRefresh:
				let reqHandler = makeErrorOnlyHandler(handler)

				requestContinuation.yield(ServerRequest.workspaceCodeLensRefresh(reqHandler))
			case .workspaceSemanticTokenRefresh:
				let reqHandler = makeErrorOnlyHandler(handler)

				requestContinuation.yield(ServerRequest.workspaceSemanticTokenRefresh(reqHandler))
			case .windowShowMessageRequest:
				let params = try decodeRequestParams(ShowMessageRequestParams.self, from: data)
				let reqHandler: ServerRequest.Handler<ShowMessageRequestResponse> = makeHandler(handler)

				requestContinuation.yield(ServerRequest.windowShowMessageRequest(params, reqHandler))
			case .windowShowDocument:
				let params = try decodeRequestParams(ShowDocumentParams.self, from: data)
				let reqHandler: ServerRequest.Handler<ShowDocumentResult> = makeHandler(handler)

				requestContinuation.yield(ServerRequest.windowShowDocument(params, reqHandler))
			case .windowWorkDoneProgressCreate:
				let params = try decodeRequestParams(WorkDoneProgressCreateParams.self, from: data)
				let reqHandler = makeErrorOnlyHandler(handler)

				requestContinuation.yield(ServerRequest.windowWorkDoneProgressCreate(params, reqHandler))

			}

		} catch {
			// should we backchannel this to the client somehow?
			print("failed to relay request: \(error)")
		}
	}
}
