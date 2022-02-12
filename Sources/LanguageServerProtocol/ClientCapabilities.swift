import Foundation
import AnyCodable
import struct SwiftLSPClient.WorkspaceClientCapabilities
import struct SwiftLSPClient.TextDocumentClientCapabilities

public struct ShowDocumentClientCapabilities: Hashable, Codable {
    public var support: Bool
}

public struct ShowMessageRequestClientCapabilities: Hashable, Codable {
    public struct MessageActionItemCapabilities: Hashable, Codable {
        public var additionalPropertiesSupport: Bool
    }

    public var messageActionItem: MessageActionItemCapabilities

    init(messageActionItem: MessageActionItemCapabilities) {
        self.messageActionItem = messageActionItem
    }
}

public struct WindowClientCapabilities: Hashable, Codable {
    public var workDoneProgress: Bool
    public var showMessage: ShowMessageRequestClientCapabilities
    public var showDocument: ShowDocumentClientCapabilities

    public init(workDoneProgress: Bool, showMessage: ShowMessageRequestClientCapabilities, showDocument: ShowDocumentClientCapabilities) {
        self.workDoneProgress = workDoneProgress
        self.showMessage = showMessage
        self.showDocument = showDocument
    }
}

public struct RegularExpressionsClientCapabilities: Hashable, Codable {
    public var engine: String
    public var version: String?

    public init(engine: String, version: String? = nil) {
        self.engine = engine
        self.version = version
    }
}

public struct MarkdownClientCapabilities: Hashable, Codable {
    public var parser: String
    public var version: String?
    public var allowedTags: [String]?

    public init(parser: String, version: String? = nil, allowedTags: [String]? = nil) {
        self.parser = parser
        self.version = version
        self.allowedTags = allowedTags
    }
}

public struct GeneralClientCapabilities: Hashable, Codable {
    public var regularExpressions: RegularExpressionsClientCapabilities?
    public var markdown: MarkdownClientCapabilities?

    public init(regularExpressions: RegularExpressionsClientCapabilities?, markdown: MarkdownClientCapabilities?) {
        self.regularExpressions = regularExpressions
        self.markdown = markdown
    }
}

public struct ClientCapabilities: Codable {
    public let workspace: WorkspaceClientCapabilities?
    public let textDocument: TextDocumentClientCapabilities?
    public var window: WindowClientCapabilities?
    public var general: GeneralClientCapabilities?
    public let experimental: LSPAny

    public init(workspace: WorkspaceClientCapabilities?, textDocument: TextDocumentClientCapabilities?, window: WindowClientCapabilities?, general: GeneralClientCapabilities?, experimental: LSPAny) {
        self.workspace = workspace
        self.textDocument = textDocument
        self.window = window
        self.general = general
        self.experimental = experimental
    }
}
