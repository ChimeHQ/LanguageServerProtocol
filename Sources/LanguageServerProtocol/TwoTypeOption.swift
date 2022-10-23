import Foundation

public enum TwoTypeOption<T, U> {
    case optionA(T)
    case optionB(U)
}

extension TwoTypeOption: Codable where T: Codable, U: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            let value = try container.decode(T.self)
            self = .optionA(value)
        } catch is DecodingError {
            let value = try container.decode(U.self)
            self = .optionB(value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .optionA(let value):
            try container.encode(value)
        case .optionB(let value):
            try container.encode(value)
        }
    }
}

extension TwoTypeOption: Equatable where T: Equatable, U: Equatable {
}

extension TwoTypeOption: Hashable where T: Hashable, U: Hashable {
}

extension TwoTypeOption: Sendable where T: Sendable, U: Sendable {
}
