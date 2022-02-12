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
