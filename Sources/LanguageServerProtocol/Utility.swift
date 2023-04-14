import Foundation

public struct GenericDynamicRegistration: Codable, Hashable, Sendable {
    public let dynamicRegistration: Bool?

    public init(dynamicRegistration: Bool) {
        self.dynamicRegistration = dynamicRegistration
    }
}
