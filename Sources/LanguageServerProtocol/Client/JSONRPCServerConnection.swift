import Foundation
import JSONRPC

public actor JSONRPCServerConnection: ServerConnection {
	public let eventSequence: EventSequence
	private let eventContinuation: EventSequence.Continuation
	private var eventTask: Task<Void, Never>?

	private let session: JSONRPCSession

	/// NOTE: The channel will wrapped with message framing
	public init(dataChannel: DataChannel) {
		self.session = JSONRPCSession(channel: dataChannel.withMessageFraming())

		(self.eventSequence, self.eventContinuation) = EventSequence.makeStream()

		Task {
			await startMonitoringSession()
		}
	}

	deinit {
		eventTask?.cancel()
		eventContinuation.finish()
	}

	private func startMonitoringSession() async {
		let seq = await session.eventSequence

		for await event in seq {


			switch event {
			case let .notification(notification, data):
				self.handleNotification(notification, data: data)
			case let .request(request, handler, data):
				self.handleRequest(request, data: data, handler: handler)
			case .error:
				break // TODO?
			}

		}

		eventContinuation.finish()
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
		case .textDocumentDidOpen(let params):
			try await session.sendNotification(params, method: method)
		case .textDocumentDidClose(let params):
			try await session.sendNotification(params, method: method)
		case .textDocumentWillSave(let params):
			try await session.sendNotification(params, method: method)
		case .textDocumentDidSave(let params):
			try await session.sendNotification(params, method: method)
		case .workspaceDidChangeWatchedFiles(let params):
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
		case .initialize(let params, _):
			return try await session.response(to: method, params: params)
		case .shutdown:
			return try await session.response(to: method)
		case .workspaceExecuteCommand(let params, _):
			return try await session.response(to: method, params: params)
		case .workspaceInlayHintRefresh:
			return try await session.response(to: method)
		case .workspaceWillCreateFiles(let params, _):
			return try await session.response(to: method, params: params)
		case .workspaceWillRenameFiles(let params, _):
			return try await session.response(to: method, params: params)
		case .workspaceWillDeleteFiles(let params, _):
			return try await session.response(to: method, params: params)
		case .workspaceSymbol(let params, _):
			return try await session.response(to: method, params: params)
		case .workspaceSymbolResolve(let params, _):
			return try await session.response(to: method, params: params)
		case .textDocumentWillSaveWaitUntil(let params, _):
			return try await session.response(to: method, params: params)
		case .completion(let params, _):
			return try await session.response(to: method, params: params)
		case .completionItemResolve(let params, _):
			return try await session.response(to: method, params: params)
		case .hover(let params, _):
			return try await session.response(to: method, params: params)
		case .signatureHelp(let params, _):
			return try await session.response(to: method, params: params)
		case .declaration(let params, _):
			return try await session.response(to: method, params: params)
		case .definition(let params, _):
			return try await session.response(to: method, params: params)
		case .typeDefinition(let params, _):
			return try await session.response(to: method, params: params)
		case .implementation(let params, _):
			return try await session.response(to: method, params: params)
		case .documentHighlight(let params, _):
			return try await session.response(to: method, params: params)
		case .documentSymbol(let params, _):
			return try await session.response(to: method, params: params)
		case .codeAction(let params, _):
			return try await session.response(to: method, params: params)
		case .codeActionResolve(let params, _):
			return try await session.response(to: method, params: params)
		case .codeLens(let params, _):
			return try await session.response(to: method, params: params)
		case .codeLensResolve(let params, _):
			return try await session.response(to: method, params: params)
		case .selectionRange(let params, _):
			return try await session.response(to: method, params: params)
		case .linkedEditingRange(let params, _):
			return try await session.response(to: method, params: params)
		case .prepareCallHierarchy(let params, _):
			return try await session.response(to: method, params: params)
		case .prepareRename(let params, _):
			return try await session.response(to: method, params: params)
		case .prepareTypeHierarchy(let params, _):
			return try await session.response(to: method, params: params)
		case .rename(let params, _):
			return try await session.response(to: method, params: params)
		case .inlayHint(let params, _):
			return try await session.response(to: method, params: params)
		case .inlayHintResolve(let params, _):
			return try await session.response(to: method, params: params)
		case .diagnostics(let params, _):
			return try await session.response(to: method, params: params)
		case .documentLink(let params, _):
			return try await session.response(to: method, params: params)
		case .documentLinkResolve(let params, _):
			return try await session.response(to: method, params: params)
		case .documentColor(let params, _):
			return try await session.response(to: method, params: params)
		case .colorPresentation(let params, _):
			return try await session.response(to: method, params: params)
		case .formatting(let params, _):
			return try await session.response(to: method, params: params)
		case .rangeFormatting(let params, _):
			return try await session.response(to: method, params: params)
		case .onTypeFormatting(let params, _):
			return try await session.response(to: method, params: params)
		case .references(let params, _):
			return try await session.response(to: method, params: params)
		case .foldingRange(let params, _):
			return try await session.response(to: method, params: params)
		case .moniker(let params, _):
			return try await session.response(to: method, params: params)
		case .semanticTokensFull(let params, _):
			return try await session.response(to: method, params: params)
		case .semanticTokensFullDelta(let params, _):
			return try await session.response(to: method, params: params)
		case .semanticTokensRange(let params, _):
			return try await session.response(to: method, params: params)
		case .callHierarchyIncomingCalls(let params, _):
			return try await session.response(to: method, params: params)
		case .callHierarchyOutgoingCalls(let params, _):
			return try await session.response(to: method, params: params)
		case let .custom(method, params, _):
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

	private func yield(_ notification: ServerNotification) {
		eventContinuation.yield(.notification(notification))
	}

	private func yield(id: JSONId, request: ServerRequest) {
		eventContinuation.yield(.request(id: id, request: request))
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

				yield(.windowLogMessage(params))
			case .windowShowMessage:
				let params = try decodeNotificationParams(ShowMessageParams.self, from: data)

				yield(.windowShowMessage(params))
			case .textDocumentPublishDiagnostics:
				let params = try decodeNotificationParams(PublishDiagnosticsParams.self, from: data)

				yield(.textDocumentPublishDiagnostics(params))
			case .telemetryEvent:
				let params = anyNotification.params ?? .null

				yield(.telemetryEvent(params))
			case .protocolCancelRequest:
				let params = try decodeNotificationParams(CancelParams.self, from: data)

				yield(.protocolCancelRequest(params))
			case .protocolProgress:
				let params = try decodeNotificationParams(ProgressParams.self, from: data)

				yield(.protocolProgress(params))
			case .protocolLogTrace:
				let params = try decodeNotificationParams(LogTraceParams.self, from: data)

				yield(.protocolLogTrace(params))
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

	private nonisolated func makeErrorOnlyHandler(_ handler: @escaping JSONRPCEvent.RequestHandler) -> ServerRequest.ErrorOnlyHandler {
		return {
			if let error = $0 {
				await handler(.failure(error))
			} else {
				await handler(.success(JSONValue.null))
			}
		}
	}

	private nonisolated func makeHandler<T>(_ handler: @escaping JSONRPCEvent.RequestHandler) -> ServerRequest.Handler<T> {
		return {
			let loweredResult = $0.map({ $0 as Encodable & Sendable })

			await handler(loweredResult)
		}
	}

	private func handleRequest(_ anyRequest: AnyJSONRPCRequest, data: Data, handler: @escaping JSONRPCEvent.RequestHandler) {
		let methodName = anyRequest.method
		let id = anyRequest.id

		do {
			guard let method = ServerRequest.Method(rawValue: methodName) else {
				throw ServerError.unrecognizedMethod(methodName)
			}

			switch method {
			case .workspaceConfiguration:
				let params = try decodeRequestParams(ConfigurationParams.self, from: data)
				let reqHandler: ServerRequest.Handler<[LSPAny]> = makeHandler(handler)

				yield(id: id, request: ServerRequest.workspaceConfiguration(params, reqHandler))
			case .workspaceFolders:
				let reqHandler: ServerRequest.Handler<WorkspaceFoldersResponse> = makeHandler(handler)

				yield(id: id, request: ServerRequest.workspaceFolders(reqHandler))
			case .workspaceApplyEdit:
				let params = try decodeRequestParams(ApplyWorkspaceEditParams.self, from: data)
				let reqHandler: ServerRequest.Handler<ApplyWorkspaceEditResult> = makeHandler(handler)

				yield(id: id, request: ServerRequest.workspaceApplyEdit(params, reqHandler))
			case .clientRegisterCapability:
				let params = try decodeRequestParams(RegistrationParams.self, from: data)
				let reqHandler = makeErrorOnlyHandler(handler)

				yield(id: id, request: ServerRequest.clientRegisterCapability(params, reqHandler))
			case .clientUnregisterCapability:
				let params = try decodeRequestParams(UnregistrationParams.self, from: data)
				let reqHandler = makeErrorOnlyHandler(handler)

				yield(id: id, request: ServerRequest.clientUnregisterCapability(params, reqHandler))
			case .workspaceCodeLensRefresh:
				let reqHandler = makeErrorOnlyHandler(handler)

				yield(id: id, request: ServerRequest.workspaceCodeLensRefresh(reqHandler))
			case .workspaceSemanticTokenRefresh:
				let reqHandler = makeErrorOnlyHandler(handler)

				yield(id: id, request: ServerRequest.workspaceSemanticTokenRefresh(reqHandler))
			case .windowShowMessageRequest:
				let params = try decodeRequestParams(ShowMessageRequestParams.self, from: data)
				let reqHandler: ServerRequest.Handler<ShowMessageRequestResponse> = makeHandler(handler)

				yield(id: id, request: ServerRequest.windowShowMessageRequest(params, reqHandler))
			case .windowShowDocument:
				let params = try decodeRequestParams(ShowDocumentParams.self, from: data)
				let reqHandler: ServerRequest.Handler<ShowDocumentResult> = makeHandler(handler)

				yield(id: id, request: ServerRequest.windowShowDocument(params, reqHandler))
			case .windowWorkDoneProgressCreate:
				let params = try decodeRequestParams(WorkDoneProgressCreateParams.self, from: data)
				let reqHandler = makeErrorOnlyHandler(handler)

				yield(id: id, request: ServerRequest.windowWorkDoneProgressCreate(params, reqHandler))

			}

		} catch {
			// should we backchannel this to the client somehow?
			print("failed to relay request: \(error)")
		}
	}
}
