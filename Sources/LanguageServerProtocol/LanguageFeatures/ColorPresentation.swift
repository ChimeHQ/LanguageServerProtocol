import Foundation

public struct ColorPresentationParams: Codable, Hashable {
    public let workDoneToken: ProgressToken?
    public let partialResultToken: ProgressToken?
    public let textDocument: TextDocumentIdentifier
    public let color: Color
    public let range: LSPRange

    public init(workDoneToken: ProgressToken? = nil, partialResultToken: ProgressToken? = nil, textDocument: TextDocumentIdentifier, color: Color, range: LSPRange) {
        self.workDoneToken = workDoneToken
        self.partialResultToken = partialResultToken
        self.textDocument = textDocument
        self.color = color
        self.range = range
    }
}

public struct ColorPresentation: Codable, Hashable {
    public let label: String
    public let textEdit: TextEdit?
    public let additionalTextEdits: [TextEdit]?
}

public typealias ColorPresentationResponse = [ColorPresentation]
