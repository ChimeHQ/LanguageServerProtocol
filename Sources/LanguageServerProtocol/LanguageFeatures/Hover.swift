import Foundation

public struct HoverClientCapabilities: Codable, Hashable {
    public var dynamicRegistration: Bool?
    public var contentFormat: [MarkupKind]?

    public init(dynamicRegistration: Bool?, contentFormat: [MarkupKind]?) {
        self.dynamicRegistration = dynamicRegistration
        self.contentFormat = contentFormat
    }
}

public struct Hover: Codable, Hashable {
    public let contents: ThreeTypeOption<MarkedString, [MarkedString], MarkupContent>
    public let range: LSPRange?
}

public typealias HoverResponse = Hover?
