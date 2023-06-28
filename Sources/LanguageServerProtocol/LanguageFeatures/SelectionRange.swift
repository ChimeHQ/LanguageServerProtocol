import Foundation

public typealias SelectionRangeClientCapabilities = DynamicRegistrationClientCapabilities

public typealias SelectionRangeOptions = WorkDoneProgressOptions

public typealias SelectionRangeRegistrationOptions = StaticRegistrationWorkDoneProgressTextDocumentRegistrationOptions

public struct SelectionRangeParams: Codable, Hashable, Sendable {
    public let workDoneToken: ProgressToken?
    public let partialResultToken: ProgressToken?
    public let textDocument: TextDocumentIdentifier
    public let positions: [Position]

    public init(workDoneToken: ProgressToken? = nil, partialResultToken: ProgressToken? = nil, textDocument: TextDocumentIdentifier, positions: [Position]) {
        self.workDoneToken = workDoneToken
        self.partialResultToken = partialResultToken
        self.textDocument = textDocument
        self.positions = positions
    }
}

public final class SelectionRange: Codable, Sendable {
    public let range: LSPRange
    public let parent: SelectionRange?
}

extension SelectionRange: Equatable {
    public static func == (lhs: SelectionRange, rhs: SelectionRange) -> Bool {
        return lhs.range == rhs.range && lhs.parent == rhs.parent
    }
}

public typealias SelectionRangeResponse = [SelectionRange]?
