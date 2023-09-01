import JSONRPC
import Foundation
import LanguageServerProtocol

public protocol Server {
  typealias NotificationSequence = AsyncStream<ClientNotification>
	typealias RequestSequence = AsyncStream<ClientRequest>

	var notificationSequence: NotificationSequence { get }
	var requestSequence: RequestSequence { get }
	var errorSequence: JSONRPCSession.ErrorSequence { get }

	func sendNotification(_ notif: ServerNotification) async throws
	func sendRequest<Response: Decodable & Sendable>(_ request: ServerRequest) async throws -> Response
}
