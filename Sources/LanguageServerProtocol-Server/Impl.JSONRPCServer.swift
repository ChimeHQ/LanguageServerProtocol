import Foundation
import JSONRPC
import LanguageServerProtocol

public actor JSONRPCServer : Server {
	public let eventSequence: EventSequence
	private let eventContinuation: EventSequence.Continuation
	private var eventTask: Task<Void, Never>?

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
			case let .error(error):
				self.handleError(error)
			}
		}

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

	private func yield(_ request: ClientRequest) {
		eventContinuation.yield(.request(request))
	}

	private func yield(_ error: ClientError) {
		eventContinuation.yield(.error(error))
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
          let params = try decodeNotificationParams(TextDocumentDidOpenParams.self, from: data)
          yield(.textDocumentDidOpen(params))
        case .textDocumentDidChange:
          let params = try decodeNotificationParams(TextDocumentDidChangeParams.self, from: data)
          yield(.textDocumentDidChange(params))
        case .textDocumentDidClose:
          let params = try decodeNotificationParams(TextDocumentDidCloseParams.self, from: data)
          yield(.textDocumentDidClose(params))
        case .textDocumentWillSave:
          let params = try decodeNotificationParams(TextDocumentWillSaveParams.self, from: data)
          yield(.textDocumentWillSave(params))
        case .textDocumentDidSave:
          let params = try decodeNotificationParams(TextDocumentDidSaveParams.self, from: data)
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

		do {
			guard let method = ClientRequest.Method(rawValue: methodName) else {
				throw ClientError.unrecognizedMethod(methodName)
			}

			switch method {
			case .initialize:
				yield(ClientRequest.initialize(try decodeRequestParams(data), makeHandler(handler)))
			case .shutdown:
				yield(ClientRequest.shutdown)

			case .workspaceExecuteCommand:
				yield(ClientRequest.workspaceExecuteCommand(try decodeRequestParams(data), makeHandler(handler)))
			case .workspaceWillCreateFiles:
				yield(ClientRequest.workspaceWillCreateFiles(try decodeRequestParams(data), makeHandler(handler)))
			case .workspaceWillRenameFiles:
				yield(ClientRequest.workspaceWillRenameFiles(try decodeRequestParams(data), makeHandler(handler)))
			case .workspaceWillDeleteFiles:
				yield(ClientRequest.workspaceWillDeleteFiles(try decodeRequestParams(data), makeHandler(handler)))
			case .workspaceSymbol:
				yield(ClientRequest.workspaceSymbol(try decodeRequestParams(data), makeHandler(handler)))
			case .workspaceSymbolResolve:
				yield(ClientRequest.workspaceSymbolResolve(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentWillSaveWaitUntil:
				yield(ClientRequest.textDocumentWillSaveWaitUntil(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentCompletion:
				yield(ClientRequest.completion(try decodeRequestParams(data), makeHandler(handler)))
			case .completionItemResolve:
				yield(ClientRequest.completionItemResolve(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentHover:
				yield(ClientRequest.hover(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentSignatureHelp:
				yield(ClientRequest.signatureHelp(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDeclaration:
				yield(ClientRequest.declaration(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDefinition:
				yield(ClientRequest.definition(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentTypeDefinition:
				yield(ClientRequest.typeDefinition(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentImplementation:
				yield(ClientRequest.implementation(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDiagnostic:
				yield(ClientRequest.diagnostics(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDocumentHighlight:
				yield(ClientRequest.documentHighlight(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDocumentSymbol:
				yield(ClientRequest.documentSymbol(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentCodeAction:
				yield(ClientRequest.codeAction(try decodeRequestParams(data), makeHandler(handler)))
			case .codeActionResolve:
				yield(ClientRequest.codeActionResolve(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentCodeLens:
				yield(ClientRequest.codeLens(try decodeRequestParams(data), makeHandler(handler)))
			case .codeLensResolve:
				yield(ClientRequest.codeLensResolve(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentSelectionRange:
				yield(ClientRequest.selectionRange(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentLinkedEditingRange:
				yield(ClientRequest.linkedEditingRange(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentPrepareCallHierarchy:
				yield(ClientRequest.prepareCallHierarchy(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentPrepareRename:
				yield(ClientRequest.prepareRename(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentRename:
				yield(ClientRequest.rename(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDocumentLink:
				yield(ClientRequest.documentLink(try decodeRequestParams(data), makeHandler(handler)))
			case .documentLinkResolve:
				yield(ClientRequest.documentLinkResolve(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentDocumentColor:
				yield(ClientRequest.documentColor(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentColorPresentation:
				yield(ClientRequest.colorPresentation(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentFormatting:
				yield(ClientRequest.formatting(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentRangeFormatting:
				yield(ClientRequest.rangeFormatting(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentOnTypeFormatting:
				yield(ClientRequest.onTypeFormatting(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentReferences:
				yield(ClientRequest.references(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentFoldingRange:
				yield(ClientRequest.foldingRange(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentMoniker:
				yield(ClientRequest.moniker(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentSemanticTokens:
				throw ClientError.unhandledRegisterationMethod(methodName)
			case .textDocumentSemanticTokensFull:
				yield(ClientRequest.semanticTokensFull(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentSemanticTokensFullDelta:
				yield(ClientRequest.semanticTokensFullDelta(try decodeRequestParams(data), makeHandler(handler)))
			case .textDocumentSemanticTokensRange:
				yield(ClientRequest.semanticTokensRange(try decodeRequestParams(data), makeHandler(handler)))
			case .callHierarchyIncomingCalls:
				yield(ClientRequest.callHierarchyIncomingCalls(try decodeRequestParams(data), makeHandler(handler)))
			case .callHierarchyOutgoingCalls:
				yield(ClientRequest.callHierarchyOutgoingCalls(try decodeRequestParams(data), makeHandler(handler)))
			case .custom:
				yield(ClientRequest.custom(methodName, try decodeRequestParams(data), makeHandler(handler)))
			}

		} catch {
			// should we backchannel this to the client somehow?
			print("failed to relay request: \(error)")
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
