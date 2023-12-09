import Foundation

public enum MessageType: Int, Codable, Hashable, Sendable {
	case error = 1
	case warning = 2
	case info = 3
	case log = 4
}

extension MessageType: CustomStringConvertible {
	public var description: String {
		switch self {
		case .error:
			return "error"
		case .warning:
			return "warning"
		case .info:
			return "info"
		case .log:
			return "log"
		}
	}
}

public struct LogMessageParams: Codable, Hashable, Sendable {
	public let type: MessageType
	public let message: String

	public init(type: MessageType, message: String) {
		self.type = type
		self.message = message
	}
}

extension LogMessageParams: CustomStringConvertible {
	public var description: String {
		return "\(type): \(message)"
	}
}

public typealias ShowMessageParams = LogMessageParams

public struct ShowDocumentParams: Hashable, Codable, Sendable {
	public var uri: URI
	public var external: Bool?
	public var takeFocus: Bool?
	public var selection: LSPRange?

	public init(uri: URI, external: Bool? = nil, takeFocus: Bool? = nil, selection: LSPRange? = nil)
	{
		self.uri = uri
		self.external = external
		self.takeFocus = takeFocus
		self.selection = selection
	}
}

public struct WorkDoneProgressCreateParams: Hashable, Codable, Sendable {
	public var token: ProgressToken

	public init(token: ProgressToken) {
		self.token = token
	}
}

public typealias WorkDoneProgressCancelParams = WorkDoneProgressCreateParams

public struct ShowDocumentResult: Hashable, Codable, Sendable {
	public let success: Bool

	public init(success: Bool) {
		self.success = success
	}
}
