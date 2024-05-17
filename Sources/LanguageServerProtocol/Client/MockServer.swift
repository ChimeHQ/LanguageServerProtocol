import Foundation

extension AsyncSequence {
	func collect() async rethrows -> [Element] {
		try await reduce(into: [Element]()) { $0.append($1) }
	}
}

/// Simulate LSP communication.
public actor MockServer: ServerConnection {
	public enum ClientMessage: Equatable, Sendable {
		case notification(ClientNotification)
		case request(ClientRequest)
	}

	public typealias ClientMessageSequence = AsyncStream<ClientMessage>
	private typealias ResponseDataSequence = AsyncStream<Data>

	public let eventSequence: EventSequence
	private let eventContinuation: EventSequence.Continuation

	private var mockResponses = [Data]()

	public let sentMessageSequence: ClientMessageSequence
	private let sentMessageContinuation: ClientMessageSequence.Continuation

	public init() {
		(self.eventSequence, self.eventContinuation) = EventSequence.makeStream()
		(self.sentMessageSequence, self.sentMessageContinuation) =
			ClientMessageSequence.makeStream()
	}

	deinit {
		sentMessageContinuation.finish()
		eventContinuation.finish()
	}

	public func sendNotification(_ notif: ClientNotification) async throws {
		sentMessageContinuation.yield(.notification(notif))
	}

	public func sendRequest<Response>(_ request: ClientRequest) async throws -> Response
	where Response: Decodable, Response: Sendable {
		sentMessageContinuation.yield(.request(request))

		if mockResponses.isEmpty {
			throw ProtocolError.missingReply
		}

		let data = mockResponses.removeFirst()

		return try JSONDecoder().decode(Response.self, from: data)
	}
}

extension MockServer {
	/// Returns an array of sent messages.
	public func finishSession() async -> [ClientMessage] {
		sentMessageContinuation.finish()
		eventContinuation.finish()

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
	public func sendMockResponse<Response>(_ response: Response) throws
	where Response: Encodable, Response: Sendable {
		let data = try JSONEncoder().encode(response)

		sendMockResponse(data)
	}

	/// Simulate a server request.
	public func sendMockRequest(_ request: ServerRequest) {
		eventContinuation.yield(.request(id: .numericId(0), request: request))
	}

	/// Simulate a server notification.
	public func sendMockNotification(_ note: ServerNotification) {
		eventContinuation.yield(.notification(note))
	}
}
