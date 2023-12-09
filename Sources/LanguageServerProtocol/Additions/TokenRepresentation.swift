import Foundation

/// A structure representing a Semantic Token.
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

/// Stores and updates raw Semantic Token data and converts it into Tokens.
public final class TokenRepresentation {
	private var data: [UInt32]
	public private(set) var lastResultId: String?
	public let legend: SemanticTokensLegend

	public init(legend: SemanticTokensLegend) {
		self.data = []
		self.legend = legend
	}

	/// Merge new token data with existing representation
	///
	/// - Warning: The returned range diffs are not currently calculated and will always be empty.
	///
	/// - Returns: Ranges affected by the new data (currently unimplemented).
	public func applyData(_ newData: [UInt32]) -> [LSPRange] {
		let minLength = min(data.count, newData.count)

		var diffStartIndex = 0

		for _ in 0..<minLength {
			if data[diffStartIndex] != newData[diffStartIndex] {
				break
			}

			diffStartIndex += 1
		}

		let diffRange = diffStartIndex..<data.count

		// data is the same
		if diffRange.isEmpty && data.count == newData.count {
			return []
		}

		let diffValues = newData.suffix(from: diffStartIndex)

		self.data.replaceSubrange(diffRange, with: diffValues)

		return []
	}

	/// Apply edits to the existing representation
	///
	/// - Returns: Ranges affected by the new data (currently unimplemented).
	public func applyEdits(_ edits: [SemanticTokensEdit]) -> [LSPRange] {
		// sort high to low
		let descendingEdits = edits.sorted(by: { a, b in a.start > b.start })

		for edit in descendingEdits {
			let start = Int(edit.start)
			let end = Int(edit.start + edit.deleteCount)

			let newData = edit.data ?? []

			data.replaceSubrange(start..<end, with: newData)
		}

		return []
	}

	private func makeToken(range: LSPRange, typeIndex: Int) -> Token? {
		guard typeIndex < legend.tokenTypes.endIndex else {
			return nil
		}

		let tokenType = legend.tokenTypes[typeIndex]

		return Token(range: range, tokenType: tokenType, modifiers: Set())
	}

	/// Compute `Token` values within a range.
	public func decodeTokens(in range: LSPRange) -> [Token] {
		var lastLine: Int?
		var lastStartChar: Int?

		var tokens = [Token]()

		for i in stride(from: 0, to: data.count, by: 5) {
			let lineDelta = Int(data[i])
			let startingLine = lastLine ?? 0
			let line = startingLine + lineDelta

			lastLine = line

			let charDelta = Int(data[i + 1])
			let startingChar = lastStartChar ?? 0
			let startChar = (lineDelta == 0 ? startingChar : 0) + charDelta

			lastStartChar = startChar

			let length = Int(data[i + 2])

			let start = Position(line: line, character: startChar)
			if start >= range.end {
				break
			}

			let end = Position(line: line, character: startChar + length)
			if end < range.start {
				continue
			}

			let tokenRange = LSPRange(start: start, end: end)
			let typeIndex = Int(data[i + 3])

			if let token = makeToken(range: tokenRange, typeIndex: typeIndex) {
				tokens.append(token)
			}
		}

		return tokens
	}
}

extension TokenRepresentation {
	public func applyResponse(_ response: SemanticTokensDeltaResponse) -> [LSPRange] {
		switch response {
		case .optionA(let fullResponse):
			self.lastResultId = fullResponse.resultId

			return applyData(fullResponse.data)
		case .optionB(let delta):
			self.lastResultId = delta.resultId

			return applyEdits(delta.edits)
		case nil:
			return []
		}
	}

	public func applyResponse(_ response: SemanticTokensResponse) -> [LSPRange] {
		guard let response = response else {
			self.lastResultId = nil
			self.data = []

			return []
		}

		self.lastResultId = response.resultId

		return applyData(response.data)
	}
}
