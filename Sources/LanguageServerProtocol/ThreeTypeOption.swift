import Foundation

public enum ThreeTypeOption<T, U, V> {
	case optionA(T)
	case optionB(U)
	case optionC(V)
}

extension ThreeTypeOption: Codable where T: Codable, U: Codable, V: Codable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		do {
			let value = try container.decode(T.self)
			self = .optionA(value)
		} catch is DecodingError {
			do {
				let value = try container.decode(U.self)
				self = .optionB(value)
			} catch is DecodingError {
				let value = try container.decode(V.self)
				self = .optionC(value)
			}
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .optionA(let value):
			try container.encode(value)
		case .optionB(let value):
			try container.encode(value)
		case .optionC(let value):
			try container.encode(value)
		}
	}
}

extension ThreeTypeOption: Equatable where T: Equatable, U: Equatable, V: Equatable {}
extension ThreeTypeOption: Hashable where T: Hashable, U: Hashable, V: Hashable {}
extension ThreeTypeOption: Sendable where T: Sendable, U: Sendable, V: Sendable {}
