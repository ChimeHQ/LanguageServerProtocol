import JSONRPC
import Foundation
import LanguageServerProtocol

public protocol Server {
	typealias EventSequence = AsyncStream<ClientEvent>

	var eventSequence: EventSequence { get }

	func sendNotification(_ notif: ServerNotification) async throws
	func sendRequest<Response: Decodable & Sendable>(_ request: ServerRequest) async throws -> Response
}
