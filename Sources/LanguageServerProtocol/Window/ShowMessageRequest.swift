import Foundation

public struct MessageActionItem: Codable, Hashable, Sendable {
	public var title: String
}

public struct ShowMessageRequestParams: Codable, Hashable, Sendable {
	public var type: MessageType
	public var message: String
	public var actions: [MessageActionItem]?
}

extension ShowMessageRequestParams: CustomStringConvertible {
	public var description: String {
		return "\(type): \(message)"
	}
}

public typealias ShowMessageRequestResponse = MessageActionItem?
