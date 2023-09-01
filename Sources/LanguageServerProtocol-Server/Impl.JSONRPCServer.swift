import Foundation
import JSONRPC
import LanguageServerProtocol

public actor JSONRPCServer : Server {
	public let notificationSequence: NotificationSequence
	public let requestSequence: RequestSequence
	public let errorSequence: JSONRPCSession.ErrorSequence
	// public nonisolated let errorSequence: JSONRPCSession.ErrorSequence { session.errorSequence }

	private let notificationContinuation: NotificationSequence.Continuation
	private let requestContinuation: RequestSequence.Continuation
	private let errorContinuation: JSONRPCSession.ErrorSequence.Continuation

	private let session: JSONRPCSession
	private var notificationTask: Task<Void, Never>?
	private var requestTask: Task<Void, Never>?
	private var errorTask: Task<Void, Never>?

	/// NOTE: The channel will wrapped with message framing
	public init(_ dataChannel: DataChannel) {
		self.session = JSONRPCSession(channel: dataChannel.withMessageFraming())

		(self.notificationSequence, self.notificationContinuation) = NotificationSequence.makeStream()
		(self.requestSequence, self.requestContinuation) = RequestSequence.makeStream()
		(self.errorSequence, self.errorContinuation) = JSONRPCSession.ErrorSequence.makeStream()

		Task {
			await startMonitoringSession()
		}
	}

	deinit {
		notificationTask?.cancel()
		notificationContinuation.finish()

		requestTask?.cancel()
		requestContinuation.finish()

    errorTask?.cancel()
		errorContinuation.finish()
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

		let errorSequence = await session.errorSequence

		self.errorTask = Task { [weak self] in
			for await err in errorSequence {
        guard let self = self else { break }

        self.errorContinuation.yield(err)
			}

			self?.errorContinuation.finish()
		}

	}


	private func decodeNotificationParams<Params>(_ type: Params.Type, from data: Data) throws -> Params where Params : Decodable {
		let note = try JSONDecoder().decode(JSONRPCNotification<Params>.self, from: data)

		guard let params = note.params else {
			throw ClientError.missingParams
		}

		return params
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
          notificationContinuation.yield(.initialized(params))
        case .exit:
          notificationContinuation.yield(.exit)
        case .textDocumentDidOpen:
          let params = try decodeNotificationParams(TextDocumentDidOpenParams.self, from: data)
          notificationContinuation.yield(.textDocumentDidOpen(params))
        case .textDocumentDidChange:
          let params = try decodeNotificationParams(TextDocumentDidChangeParams.self, from: data)
          notificationContinuation.yield(.textDocumentDidChange(params))
        case .textDocumentDidClose:
          let params = try decodeNotificationParams(TextDocumentDidCloseParams.self, from: data)
          notificationContinuation.yield(.textDocumentDidClose(params))
        case .textDocumentWillSave:
          let params = try decodeNotificationParams(TextDocumentWillSaveParams.self, from: data)
          notificationContinuation.yield(.textDocumentWillSave(params))
        case .textDocumentDidSave:
          let params = try decodeNotificationParams(TextDocumentDidSaveParams.self, from: data)
          notificationContinuation.yield(.textDocumentDidSave(params))
        case .protocolCancelRequest:
          let params = try decodeNotificationParams(CancelParams.self, from: data)
          notificationContinuation.yield(.protocolCancelRequest(params))
        case .protocolSetTrace:
          let params = try decodeNotificationParams(SetTraceParams.self, from: data)
          notificationContinuation.yield(.protocolSetTrace(params))
        case .workspaceDidChangeWatchedFiles:
          let params = try decodeNotificationParams(DidChangeWatchedFilesParams.self, from: data)
          notificationContinuation.yield(.workspaceDidChangeWatchedFiles(params))
        case .windowWorkDoneProgressCancel:
          let params = try decodeNotificationParams(WorkDoneProgressCancelParams.self, from: data)
          notificationContinuation.yield(.windowWorkDoneProgressCancel(params))
        case .workspaceDidChangeWorkspaceFolders:
          let params = try decodeNotificationParams(DidChangeWorkspaceFoldersParams.self, from: data)
          notificationContinuation.yield(.workspaceDidChangeWorkspaceFolders(params))
        case .workspaceDidChangeConfiguration:
          let params = try decodeNotificationParams(DidChangeConfigurationParams.self, from: data)
          notificationContinuation.yield(.workspaceDidChangeConfiguration(params))
        case .workspaceDidCreateFiles:
          let params = try decodeNotificationParams(CreateFilesParams.self, from: data)
          notificationContinuation.yield(.workspaceDidCreateFiles(params))
        case .workspaceDidRenameFiles:
          let params = try decodeNotificationParams(RenameFilesParams.self, from: data)
          notificationContinuation.yield(.workspaceDidRenameFiles(params))
        case .workspaceDidDeleteFiles:
          let params = try decodeNotificationParams(DeleteFilesParams.self, from: data)
          notificationContinuation.yield(.workspaceDidDeleteFiles(params))
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
			guard let method = ClientRequest.Method(rawValue: methodName) else {
				throw ClientError.unrecognizedMethod(methodName)
			}

			switch method {
        case .initialize:
          requestContinuation.yield(ClientRequest.initialize(try decodeRequestParams(data), makeHandler(handler)))
        case .shutdown:
          requestContinuation.yield(ClientRequest.shutdown)

        case .workspaceExecuteCommand:
          requestContinuation.yield(ClientRequest.workspaceExecuteCommand(try decodeRequestParams(data), makeHandler(handler)))
        case .workspaceWillCreateFiles:
          requestContinuation.yield(ClientRequest.workspaceWillCreateFiles(try decodeRequestParams(data), makeHandler(handler)))
        case .workspaceWillRenameFiles:
          requestContinuation.yield(ClientRequest.workspaceWillRenameFiles(try decodeRequestParams(data), makeHandler(handler)))
        case .workspaceWillDeleteFiles:
          requestContinuation.yield(ClientRequest.workspaceWillDeleteFiles(try decodeRequestParams(data), makeHandler(handler)))
        case .workspaceSymbol:
          requestContinuation.yield(ClientRequest.workspaceSymbol(try decodeRequestParams(data), makeHandler(handler)))

        case .workspaceSymbolResolve:
          requestContinuation.yield(ClientRequest.workspaceSymbolResolve(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentWillSaveWaitUntil:
          requestContinuation.yield(ClientRequest.textDocumentWillSaveWaitUntil(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentCompletion:
          requestContinuation.yield(ClientRequest.completion(try decodeRequestParams(data), makeHandler(handler)))
        case .completionItemResolve:
          requestContinuation.yield(ClientRequest.completionItemResolve(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentHover:
          requestContinuation.yield(ClientRequest.hover(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentSignatureHelp:
          requestContinuation.yield(ClientRequest.signatureHelp(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentDeclaration:
          requestContinuation.yield(ClientRequest.declaration(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentDefinition:
          requestContinuation.yield(ClientRequest.definition(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentTypeDefinition:
          requestContinuation.yield(ClientRequest.typeDefinition(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentImplementation:
          requestContinuation.yield(ClientRequest.implementation(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentDiagnostic:
          requestContinuation.yield(ClientRequest.diagnostics(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentDocumentHighlight:
          requestContinuation.yield(ClientRequest.documentHighlight(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentDocumentSymbol:
          requestContinuation.yield(ClientRequest.documentSymbol(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentCodeAction:
          requestContinuation.yield(ClientRequest.codeAction(try decodeRequestParams(data), makeHandler(handler)))
        case .codeActionResolve:
          requestContinuation.yield(ClientRequest.codeActionResolve(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentCodeLens:
          requestContinuation.yield(ClientRequest.codeLens(try decodeRequestParams(data), makeHandler(handler)))
        case .codeLensResolve:
          requestContinuation.yield(ClientRequest.codeLensResolve(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentSelectionRange:
          requestContinuation.yield(ClientRequest.selectionRange(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentLinkedEditingRange:
          requestContinuation.yield(ClientRequest.linkedEditingRange(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentPrepareCallHierarchy:
          requestContinuation.yield(ClientRequest.prepareCallHierarchy(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentPrepareRename:
          requestContinuation.yield(ClientRequest.prepareRename(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentRename:
          requestContinuation.yield(ClientRequest.rename(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentDocumentLink:
          requestContinuation.yield(ClientRequest.documentLink(try decodeRequestParams(data), makeHandler(handler)))
        case .documentLinkResolve:
          requestContinuation.yield(ClientRequest.documentLinkResolve(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentDocumentColor:
          requestContinuation.yield(ClientRequest.documentColor(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentColorPresentation:
          requestContinuation.yield(ClientRequest.colorPresentation(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentFormatting:
          requestContinuation.yield(ClientRequest.formatting(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentRangeFormatting:
          requestContinuation.yield(ClientRequest.rangeFormatting(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentOnTypeFormatting:
          requestContinuation.yield(ClientRequest.onTypeFormatting(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentReferences:
          requestContinuation.yield(ClientRequest.references(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentFoldingRange:
          requestContinuation.yield(ClientRequest.foldingRange(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentMoniker:
          requestContinuation.yield(ClientRequest.moniker(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentSemanticTokens:
          throw ClientError.unhandledRegisterationMethod(methodName)
        case .textDocumentSemanticTokensFull:
          requestContinuation.yield(ClientRequest.semanticTokensFull(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentSemanticTokensFullDelta:
          requestContinuation.yield(ClientRequest.semanticTokensFullDelta(try decodeRequestParams(data), makeHandler(handler)))
        case .textDocumentSemanticTokensRange:
          requestContinuation.yield(ClientRequest.semanticTokensRange(try decodeRequestParams(data), makeHandler(handler)))
        case .callHierarchyIncomingCalls:
          requestContinuation.yield(ClientRequest.callHierarchyIncomingCalls(try decodeRequestParams(data), makeHandler(handler)))
        case .callHierarchyOutgoingCalls:
          requestContinuation.yield(ClientRequest.callHierarchyOutgoingCalls(try decodeRequestParams(data), makeHandler(handler)))
        case .custom:
          requestContinuation.yield(ClientRequest.custom(methodName, try decodeRequestParams(data), makeHandler(handler)))
    }

		} catch {
			// should we backchannel this to the client somehow?
			print("failed to relay request: \(error)")
		}
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
