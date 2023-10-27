import LanguageServerProtocol

public struct EventDispatcher {
	private let connection: JSONRPCClientConnection
  	private let requestHandler: RequestHandler
  	private let notificationHandler: NotificationHandler
  	private let errorHandler: ErrorHandler

	public init(connection: JSONRPCClientConnection, requestHandler: RequestHandler, notificationHandler: NotificationHandler, errorHandler: ErrorHandler) {
		self.connection = connection
		self.requestHandler = requestHandler
		self.notificationHandler = notificationHandler
		self.errorHandler = errorHandler
	}

	public init(connection: JSONRPCClientConnection, eventHandler: EventHandler) {
		self.connection = connection
		self.requestHandler = eventHandler
		self.notificationHandler = eventHandler
		self.errorHandler = eventHandler
	}

	public func run() async {
		await monitorEvents()
	}

	private func monitorEvents() async {
		for await event in connection.eventSequence {
			switch event {
			case let .notification(notification):
				await notificationHandler.handleNotification(notification)
			case let .request(id, request):
				await requestHandler.handleRequest(id: id, request: request)
			case let .error(error):
				await errorHandler.internalError(error)
			}
		}
	}
}
