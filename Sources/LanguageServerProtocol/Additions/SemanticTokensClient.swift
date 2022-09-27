import Foundation

/// Handles requesting and decoding Semantic Token information.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public actor SemanticTokensClient {
	public private(set) var lastResultId: String? = nil
	private var tokenRepresentation: TokenRepresentation
	public let textDocument: TextDocumentIdentifier
	public let server: Server

	public init(legend: SemanticTokensLegend, textDocument: TextDocumentIdentifier, server: Server) {
		self.tokenRepresentation = TokenRepresentation(legend: legend)
		self.textDocument = textDocument
		self.server = server
	}

	public func tokens(in range: LSPRange, supportsDeltas: Bool = true) async throws -> [Token] {
		let response = try await requestTokens(supportsDeltas: supportsDeltas)

		switch response {
		case .optionA(let fullResponse):
			self.lastResultId = fullResponse.resultId

			_ = tokenRepresentation.applyData(fullResponse.data)
		case .optionB(let delta):
			self.lastResultId = delta.resultId

			_ = tokenRepresentation.applyEdits(delta.edits)
		case nil:
			return []
		}

		return tokenRepresentation.decodeTokens(in: range)
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
}
