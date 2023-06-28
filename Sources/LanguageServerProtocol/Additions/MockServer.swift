import Foundation

extension AsyncSequence {
	func collect() async rethrows -> [Element] {
		try await reduce(into: [Element]()) { $0.append($1) }
	}
}

/// Simulate LSP communication.
public actor MockServer: Server {
	public enum ClientMessage: Sendable, Hashable {
		case notification(ClientNotification)
		case request(ClientRequest)
	}

	public typealias ClientMessageSequence = AsyncStream<ClientMessage>
	private typealias ResponseDataSequence = AsyncStream<Data>

	public let notificationSequence: NotificationSequence
	public let requestSequence: RequestSequence

	private let notificationContinuation: NotificationSequence.Continuation
	private let requestContinuation: RequestSequence.Continuation

	private var mockResponses = [Data]()

	public let sentMessageSequence: ClientMessageSequence
	private let sentMessageContinuation: ClientMessageSequence.Continuation

	public init() {
		(self.notificationSequence, self.notificationContinuation) = NotificationSequence.makeStream()
		(self.requestSequence, self.requestContinuation) = RequestSequence.makeStream()
		(self.sentMessageSequence, self.sentMessageContinuation) = ClientMessageSequence.makeStream()
	}

	deinit {
		sentMessageContinuation.finish()
		notificationContinuation.finish()
		requestContinuation.finish()
	}

	public func sendNotification(_ notif: ClientNotification) async throws {
		sentMessageContinuation.yield(.notification(notif))
	}

	public func sendRequest<Response>(_ request: ClientRequest) async throws -> Response where Response : Decodable, Response : Sendable {
		sentMessageContinuation.yield(.request(request))

		if mockResponses.isEmpty {
			throw ServerError.missingReply
		}

		let data = mockResponses.removeFirst()

		return try JSONDecoder().decode(Response.self, from: data)
	}
}

extension MockServer {
	/// Returns an array of sent messages.
	public func finishSession() async -> [ClientMessage] {
		sentMessageContinuation.finish()
		notificationContinuation.finish()
		requestContinuation.finish()

		return await sentMessageSequence.collect()
	}

	/// Simulate a server response.
	public func sendMockResponse(_ data: Data) {
		mockResponses.append(data)
	}

	/// Simulate a server response.
	public func sendMockResponse(_ string: String) {
		sendMockResponse(string.data(using: .utf8)!)
	}

	/// Simulate a server response.
	public func sendMockResponse<Response>(_ response: Response) throws where Response : Encodable, Response : Sendable {
		let data = try JSONEncoder().encode(response)

		sendMockResponse(data)
	}

	/// Simulate a server request.
	public func sendMockRequest(_ request: ServerRequest) {
		requestContinuation.yield(request)
	}

	/// Simulate a server notification.
	public func sendMockNotification(_ note: ServerNotification) {
		notificationContinuation.yield(note)
	}
}
