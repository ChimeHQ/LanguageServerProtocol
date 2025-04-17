import Foundation

public struct MessageActionItem: Codable, Hashable, Sendable {
	public var title: String

	public init(title: String) {
		self.title = title
	}
}

public struct ShowMessageRequestParams: Codable, Hashable, Sendable {
	public var type: MessageType
	public var message: String
	public var actions: [MessageActionItem]?

	public init(type: MessageType, message: String, actions: [MessageActionItem]? = nil) {
		self.type = type
		self.message = message
		self.actions = actions
	}
}

extension ShowMessageRequestParams: CustomStringConvertible {
	public var description: String {
		return "\(type): \(message)"
	}
}

public typealias ShowMessageRequestResponse = MessageActionItem?
