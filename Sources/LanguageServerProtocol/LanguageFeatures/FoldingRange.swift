import Foundation

public struct FoldingRangeClientCapabilities: Codable, Hashable, Sendable {
    public var dynamicRegistration: Bool?
    public var rangeLimit: Int?
    public var lineFoldingOnly: Bool?

    public init(dynamicRegistration: Bool? = nil, rangeLimit: Int? = nil, lineFoldingOnly: Bool? = nil) {
        self.dynamicRegistration = dynamicRegistration
        self.rangeLimit = rangeLimit
        self.lineFoldingOnly = lineFoldingOnly
    }
}

public struct FoldingRangeParams: Codable, Hashable, Sendable {
    public let textDocument: TextDocumentIdentifier

    public init(textDocument: TextDocumentIdentifier) {
        self.textDocument = textDocument
    }
}

public enum FoldingRangeKind: String, CaseIterable, Codable, Hashable, Sendable {
    case comment
    case imports
    case region
}

public struct FoldingRange: Codable, Hashable, Sendable {
    public let startLine: Int
    public let startCharacter: Int?
    public let endLine: Int
    public let endCharacter: Int?
    public let kind: FoldingRangeKind?
}

public typealias FoldingRangeResponse = [FoldingRange]?
