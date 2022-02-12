import Foundation
import AnyCodable
import SwiftLSPClient

public typealias LSPAny = AnyCodable?

public typealias URI = String

public struct CancelParams: Hashable, Codable {
    public var id: TwoTypeOption<Int, String>

    public init(id: Int) {
        self.id = .optionA(id)
    }

    public init(id: String) {
        self.id = .optionB(id)
    }
}

public struct ProgressParams: Hashable, Codable {
    public var token: ProgressToken
    public var value: LSPAny
}

public struct LogTraceParams: Hashable, Codable {
    public var string: String
    public var verbose: String?
}

public enum TraceValue: String, Hashable, Codable {
    case off
    case messages
    case verbose
}

public struct SetTraceParams: Hashable, Codable {
    public var value: TraceValue

    public init(value: TraceValue) {
        self.value = value
    }
}
