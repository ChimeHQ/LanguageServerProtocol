import Foundation

public typealias DocumentColorClientCapabilities = DynamicRegistrationClientCapabilities

public struct DocumentColorParams: Codable, Hashable, Sendable {
    public let workDoneToken: ProgressToken?
    public let partialResultToken: ProgressToken?
    public let textDocument: TextDocumentIdentifier

    public init(textDocument: TextDocumentIdentifier, workDoneToken: ProgressToken? = nil, partialResultToken: ProgressToken? = nil) {
        self.workDoneToken = workDoneToken
        self.partialResultToken = partialResultToken
        self.textDocument = textDocument
    }
}

public struct Color: Codable, Hashable, Sendable {
    public let red: Float
    public let green: Float
    public let blue: Float
    public let alpha: Float
}

public struct ColorInformation: Codable, Hashable, Sendable {
    public let range: LSPRange
    public let color: Color
}

public typealias DocumentColorResponse = [ColorInformation]
