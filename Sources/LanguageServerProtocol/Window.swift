import Foundation
import SwiftLSPClient

public struct ShowDocumentParams: Hashable, Codable {
    public var uri: URI
    public var external: Bool?
    public var takeFocus: Bool?
    public var selection: LSPRange?

    public init(uri: URI, external: Bool? = nil, takeFocus: Bool? = nil, selection: LSPRange? = nil) {
        self.uri = uri
        self.external = external
        self.takeFocus = takeFocus
        self.selection = selection
    }
}

public struct WorkDoneProgressCreateParams: Hashable, Codable {
    public var token: ProgressToken

    public init(token: ProgressToken) {
        self.token = token
    }
}

public typealias WorkDoneProgressCancelParams = WorkDoneProgressCreateParams
