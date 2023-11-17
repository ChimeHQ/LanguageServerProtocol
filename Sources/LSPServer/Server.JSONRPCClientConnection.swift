import Foundation
import JSONRPC
import LanguageServerProtocol

public actor JSONRPCClientConnection : ClientConnection {
	public let eventSequence: EventSequence
	private let eventContinuation: EventSequence.Continuation

	private let session: JSONRPCSession

	/// NOTE: The channel will wrapped with message framing
	public init(_ dataChannel: DataChannel) {
		self.session = JSONRPCSession(channel: dataChannel.withMessageFraming())

		(self.eventSequence, self.eventContinuation) = EventSequence.makeStream()

		Task {
			await startMonitoringSession()
		}
	}

	deinit {
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
			case let .error(error):
				self.handleError(error)
			}
		}

		eventContinuation.finish()
	}

	public func stop() {
		eventContinuation.finish()
	}


	private func decodeNotificationParams<Params>(_ type: Params.Type, from data: Data) throws -> Params where Params : Decodable {
		let note = try JSONDecoder().decode(JSONRPCNotification<Params>.self, from: data)

		guard let params = note.params else {
			throw ClientError.missingParams
		}

		return params
	}

	private func yield(_ notification: ClientNotification) {
		eventContinuation.yield(.notification(notification))
	}

	private func yield(id: JSONId, request: ClientRequest) {
		eventContinuation.yield(.request(id: id, request: request))
	}

	private func handleNotification(_ anyNotification: AnyJSONRPCNotification, data: Data) {
		let methodName = anyNotification.method

		do {
			guard let method = ClientNotification.Method(rawValue: methodName) else {
				throw ClientError.unrecognizedMethod(methodName)
			}

			switch method {
        case .initialized:
          let params = try decodeNotificationParams(InitializedParams.self, from: data)
          yield(.initialized(params))
        case .exit:
          yield(.exit)
        case .textDocumentDidOpen:
          let params = try decodeNotificationParams(DidOpenTextDocumentParams.self, from: data)
          yield(.textDocumentDidOpen(params))
        case .textDocumentDidChange:
          let params = try decodeNotificationParams(DidChangeTextDocumentParams.self, from: data)
          yield(.textDocumentDidChange(params))
        case .textDocumentDidClose:
          let params = try decodeNotificationParams(DidCloseTextDocumentParams.self, from: data)
          yield(.textDocumentDidClose(params))
        case .textDocumentWillSave:
          let params = try decodeNotificationParams(WillSaveTextDocumentParams.self, from: data)
          yield(.textDocumentWillSave(params))
        case .textDocumentDidSave:
          let params = try decodeNotificationParams(DidSaveTextDocumentParams.self, from: data)
          yield(.textDocumentDidSave(params))
        case .protocolCancelRequest:
          let params = try decodeNotificationParams(CancelParams.self, from: data)
          yield(.protocolCancelRequest(params))
        case .protocolSetTrace:
          let params = try decodeNotificationParams(SetTraceParams.self, from: data)
          yield(.protocolSetTrace(params))
        case .workspaceDidChangeWatchedFiles:
          let params = try decodeNotificationParams(DidChangeWatchedFilesParams.self, from: data)
          yield(.workspaceDidChangeWatchedFiles(params))
        case .windowWorkDoneProgressCancel:
          let params = try decodeNotificationParams(WorkDoneProgressCancelParams.self, from: data)
          yield(.windowWorkDoneProgressCancel(params))
        case .workspaceDidChangeWorkspaceFolders:
          let params = try decodeNotificationParams(DidChangeWorkspaceFoldersParams.self, from: data)
          yield(.workspaceDidChangeWorkspaceFolders(params))
        case .workspaceDidChangeConfiguration:
          let params = try decodeNotificationParams(DidChangeConfigurationParams.self, from: data)
          yield(.workspaceDidChangeConfiguration(params))
        case .workspaceDidCreateFiles:
          let params = try decodeNotificationParams(CreateFilesParams.self, from: data)
          yield(.workspaceDidCreateFiles(params))
        case .workspaceDidRenameFiles:
          let params = try decodeNotificationParams(RenameFilesParams.self, from: data)
          yield(.workspaceDidRenameFiles(params))
        case .workspaceDidDeleteFiles:
          let params = try decodeNotificationParams(DeleteFilesParams.self, from: data)
          yield(.workspaceDidDeleteFiles(params))
			}
		} catch {
			// should we backchannel this to the client somehow?
			print("failed to relay notification: \(error)")
		}
	}


	private func decodeRequestParams<Params>(_ data: Data) throws -> Params where Params : Decodable {
		let req = try JSONDecoder().decode(JSONRPCRequest<Params>.self, from: data)

		guard let params = req.params else {
			throw ClientError.missingParams
		}

		return params
	}

	private func decodeRequestParams<Params>(_ type: Params.Type, from data: Data) throws -> Params where Params : Decodable {
		let req = try JSONDecoder().decode(JSONRPCRequest<Params>.self, from: data)

		guard let params = req.params else {
			throw ClientError.missingParams
		}

		return params
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
			guard let method = ClientRequest.Method(rawValue: methodName) else {
				throw ClientError.unrecognizedMethod(methodName)
			}

			switch method {
			case .initialize:
				yield(id: id, request: ClientRequest.initialize(try decodeRequestParams(data), makeHandler(handler)))
			case .shutdown:
				yield(id: id, request: ClientRequest.shutdown(makeHandler(handler)))
			case .workspaceInlayHintRefresh:
				yield(id: id, request: ClientRequest.workspaceInlayHintRefresh(makeHandler(handler)))
			case .workspaceExecuteCommand:
				yield(id: id, request: ClientRequest.workspaceExecuteCommand(try decodeRequestParams(data), makeHandler(handler)))
			case .workspaceWillCreateFiles:
				yield(id: id, request: ClientRequest.workspaceWillCreateFiles(try decodeRequestParams(data), makeHandler(handler)))
			case .workspaceWillRenameFiles:
				yield(id: id, request: ClientRequest.workspaceWillRenameFiles(try decodeRequestParams(data), makeHandler(handler)))
			case .workspaceWillDeleteFiles:
				yield(id: id, request: ClientRequest.workspaceWillDeleteFiles(try decodeRequestParams(data), makeHandler(handler)))
			case .workspaceSymbol:
				yield(id: id, request: ClientRequest.workspaceSymbol(try decodeRequestParams(data), makeHandler(handler)))
			case .workspaceSymbolResolve:
				yield(id: id, request: ClientRequest.workspaceSymbolResolve(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentWillSaveWaitUntil:
				yield(id: id, request: ClientRequest.textDocumentWillSaveWaitUntil(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentCompletion:
				yield(id: id, request: ClientRequest.completion(try decodeRequestParams(data), makeHandler(handler)))
			case .completionItemResolve:
				yield(id: id, request: ClientRequest.completionItemResolve(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentHover:
				yield(id: id, request: ClientRequest.hover(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentSignatureHelp:
				yield(id: id, request: ClientRequest.signatureHelp(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDeclaration:
				yield(id: id, request: ClientRequest.declaration(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDefinition:
				yield(id: id, request: ClientRequest.definition(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentTypeDefinition:
				yield(id: id, request: ClientRequest.typeDefinition(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentImplementation:
				yield(id: id, request: ClientRequest.implementation(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDiagnostic:
				yield(id: id, request: ClientRequest.diagnostics(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDocumentHighlight:
				yield(id: id, request: ClientRequest.documentHighlight(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDocumentSymbol:
				yield(id: id, request: ClientRequest.documentSymbol(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentCodeAction:
				yield(id: id, request: ClientRequest.codeAction(try decodeRequestParams(data), makeHandler(handler)))
			case .codeActionResolve:
				yield(id: id, request: ClientRequest.codeActionResolve(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentCodeLens:
				yield(id: id, request: ClientRequest.codeLens(try decodeRequestParams(data), makeHandler(handler)))
			case .codeLensResolve:
				yield(id: id, request: ClientRequest.codeLensResolve(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentSelectionRange:
				yield(id: id, request: ClientRequest.selectionRange(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentLinkedEditingRange:
				yield(id: id, request: ClientRequest.linkedEditingRange(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentPrepareCallHierarchy:
				yield(id: id, request: ClientRequest.prepareCallHierarchy(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentPrepareRename:
				yield(id: id, request: ClientRequest.prepareRename(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentRename:
				yield(id: id, request: ClientRequest.rename(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentInlayHint:
				yield(id: id, request: ClientRequest.inlayHint(try decodeRequestParams(data), makeHandler(handler)))
			case .inlayHintResolve:
				yield(id: id, request: ClientRequest.inlayHintResolve(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDocumentLink:
				yield(id: id, request: ClientRequest.documentLink(try decodeRequestParams(data), makeHandler(handler)))
			case .documentLinkResolve:
				yield(id: id, request: ClientRequest.documentLinkResolve(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDocumentColor:
				yield(id: id, request: ClientRequest.documentColor(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentColorPresentation:
				yield(id: id, request: ClientRequest.colorPresentation(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentFormatting:
				yield(id: id, request: ClientRequest.formatting(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentRangeFormatting:
				yield(id: id, request: ClientRequest.rangeFormatting(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentOnTypeFormatting:
				yield(id: id, request: ClientRequest.onTypeFormatting(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentReferences:
				yield(id: id, request: ClientRequest.references(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentFoldingRange:
				yield(id: id, request: ClientRequest.foldingRange(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentMoniker:
				yield(id: id, request: ClientRequest.moniker(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentSemanticTokens:
				throw ClientError.unhandleRegistrationMethod(methodName)
			case .textDocumentSemanticTokensFull:
				yield(id: id, request: ClientRequest.semanticTokensFull(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentSemanticTokensFullDelta:
				yield(id: id, request: ClientRequest.semanticTokensFullDelta(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentSemanticTokensRange:
				yield(id: id, request: ClientRequest.semanticTokensRange(try decodeRequestParams(data), makeHandler(handler)))
			case .callHierarchyIncomingCalls:
				yield(id: id, request: ClientRequest.callHierarchyIncomingCalls(try decodeRequestParams(data), makeHandler(handler)))
			case .callHierarchyOutgoingCalls:
				yield(id: id, request: ClientRequest.callHierarchyOutgoingCalls(try decodeRequestParams(data), makeHandler(handler)))
			case .custom:
				yield(id: id, request: ClientRequest.custom(methodName, try decodeRequestParams(data), makeHandler(handler)))
			}

		} catch {
			eventContinuation.yield(.error(error))
		}
	}

	private func handleError(_ anyError: Error) {
		eventContinuation.yield(.error(anyError))
	}

	public func sendNotification(_ notif: ServerNotification) async throws {
    let method = notif.method.rawValue

		switch notif {
    case .windowLogMessage(let params):
      try await session.sendNotification(params, method: method)
    case .windowShowMessage(let params):
      try await session.sendNotification(params, method: method)
    case .textDocumentPublishDiagnostics(let params):
      try await session.sendNotification(params, method: method)
    case .telemetryEvent(let params):
      try await session.sendNotification(params, method: method)
    case .protocolCancelRequest(let params):
      try await session.sendNotification(params, method: method)
    case .protocolProgress(let params):
      try await session.sendNotification(params, method: method)
    case .protocolLogTrace(let params):
      try await session.sendNotification(params, method: method)
    }
  }

	public func sendRequest<Response>(_ request: ServerRequest) async throws -> Response where Response : Decodable & Sendable {
		let method = request.method.rawValue

		switch request {

    case .workspaceConfiguration(let params, _):
      return try await session.response(to: method, params: params)
    case .workspaceFolders:
      return try await session.response(to: method)
    case .workspaceApplyEdit(let params, _):
      return try await session.response(to: method, params: params)
    case .clientRegisterCapability(let params, _):
      return try await session.response(to: method, params: params)
    case .clientUnregisterCapability(let params, _):
      return try await session.response(to: method, params: params)
    case .workspaceCodeLensRefresh:
      return try await session.response(to: method)
    case .workspaceSemanticTokenRefresh:
      return try await session.response(to: method)
    case .windowShowMessageRequest(let params, _):
      return try await session.response(to: method, params: params)
    case .windowShowDocument(let params, _):
      return try await session.response(to: method, params: params)
    case .windowWorkDoneProgressCreate(let params, _):
      return try await session.response(to: method, params: params)
    }
  }
}
