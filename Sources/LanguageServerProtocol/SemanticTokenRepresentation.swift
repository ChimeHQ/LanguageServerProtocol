import Foundation

public struct Token: Codable, Hashable, Sendable {
    public let range: LSPRange
    public let tokenType: String
    public let modifiers: Set<String>

    public init(range: LSPRange, tokenType: String, modifiers: Set<String> = Set()) {
        self.range = range
        self.tokenType = tokenType
        self.modifiers = modifiers
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public actor SemanticTokenRepresentation {
    public private(set) var lastResultId: String?
    private var data: [UInt32]
    public let legend: SemanticTokensLegend
    public let textDocument: TextDocumentIdentifier
    public let server: Server

    public init(legend: SemanticTokensLegend, textDocument: TextDocumentIdentifier, server: Server) {
        self.lastResultId = nil
        self.data = []
        self.legend = legend
        self.textDocument = textDocument
        self.server = server
    }

    public nonisolated func tokens(in range: LSPRange, supportsDeltas: Bool = true) async throws -> [Token] {
        let tokensResponse = try await requestTokens(supportsDeltas: supportsDeltas)

        _ = await handleResponse(tokensResponse)

        let tokenData = await self.data

        return decodeTokens(from: tokenData, in: range)
    }

    private func requestTokens(supportsDeltas: Bool) async throws -> SemanticTokensDeltaResponse {
        if let resultId = self.lastResultId, supportsDeltas {
            let params = SemanticTokensDeltaParams(textDocument: textDocument, previousResultId: resultId)

            return try await self.server.semanticTokensFullDelta(params: params)
        }

        let params = SemanticTokensParams(textDocument: textDocument)

        // translate to a delta response first so we can use a uniform handler for both cases
        return try await server.semanticTokensFull(params: params)
            .map({ .optionA($0) })
    }

    private func handleResponse(_ response: SemanticTokensDeltaResponse) -> [LSPRange] {
        switch response {
        case .optionA(let fullResponse):
            return applyFull(fullResponse)
        case .optionB(let delta):
            return applyDelta(delta)
        case nil:
            return []
        }
    }

    private func applyFull(_ full: SemanticTokens) -> [LSPRange] {
        self.lastResultId = full.resultId

        let minLength = min(data.count, full.data.count)

        var diffStartIndex = 0

        for _ in 0..<minLength {
            if data[diffStartIndex] != full.data[diffStartIndex] {
                break
            }

            diffStartIndex += 1
        }

        let diffRange = diffStartIndex..<data.count

        if diffRange.isEmpty && data.count > 0 {
            return []
        }

        let diffValues = full.data.suffix(from: diffStartIndex)

        self.data.replaceSubrange(diffRange, with: diffValues)

        return []
    }

    private func applyDelta(_ delta: SemanticTokensDelta) -> [LSPRange] {
        self.lastResultId = delta.resultId

        // sort high to low
        let descendingEdits = delta.edits.sorted(by: {a, b in a.start > b.start })

        for edit in descendingEdits {
            let start = Int(edit.start)
            let end = Int(edit.start + edit.deleteCount)

            let newData = edit.data ?? []

            data.replaceSubrange(start..<end, with: newData)
        }

        return []
    }

    private nonisolated func lspRange(within dataRange: Range<Int>) -> LSPRange {
        return LSPRange(startPair: (0, 0), endPair: (0, 0))
    }

    private nonisolated func makeToken(range: LSPRange, typeIndex: Int) -> Token? {
        guard typeIndex < legend.tokenTypes.endIndex else {
            return nil
        }

        let tokenType = legend.tokenTypes[typeIndex]

        return Token(range: range, tokenType: tokenType, modifiers: Set())
    }

    private nonisolated func decodeTokens(from data: [UInt32], in range: LSPRange) -> [Token] {
        var lastLine: Int?
        var lastStartChar: Int?

        var tokens = [Token]()

        for i in stride(from: 0, to: data.count, by: 5) {
            let lineDelta = Int(data[i])
            let startingLine = lastLine ?? 0
            let line = startingLine + lineDelta

            lastLine = line

            let charDelta = Int(data[i+1])
            let startingChar = lastStartChar ?? 0
            let startChar = (lineDelta == 0 ? startingChar : 0) + charDelta

            lastStartChar = startChar

            let length = Int(data[i+2])

            let start = Position(line: line, character: startChar)
            if start >= range.end {
                break
            }

            let end = Position(line: line, character: startChar + length)
            if end < range.start {
                continue
            }

            let tokenRange = LSPRange(start: start, end: end)
            let typeIndex = Int(data[i+3])

            if let token = makeToken(range: tokenRange, typeIndex: typeIndex) {
                tokens.append(token)
            }
        }

        return tokens
    }
}
