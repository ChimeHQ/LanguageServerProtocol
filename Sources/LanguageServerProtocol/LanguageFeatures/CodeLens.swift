import Foundation

public typealias CodeLensClientCapabilities = DynamicRegistrationClientCapabilities

public struct CodeLensWorkspaceClientCapabilities: Codable, Hashable, Sendable {
    public var refreshSupport: Bool?

    public init(refreshSupport: Bool? = nil) {
        self.refreshSupport = refreshSupport
    }
}

public struct CodeLensOptions: Codable, Hashable, Sendable {
    public var workDoneProgress: Bool?
    public var resolveProvider: Bool?
}

public struct CodeLensRegistrationOptions: Codable, Hashable, Sendable {
    public var documentSelector: DocumentSelector?
    public var workDoneProgress: Bool?
    public var resolveProvider: Bool?
}

public struct CodeLensParams: Codable, Hashable, Sendable {
    public var textDocument: TextDocumentIdentifier
    public var workDoneToken: ProgressToken?
    public var partialResultToken: ProgressToken?

    public init(textDocument: TextDocumentIdentifier, workDoneToken: ProgressToken? = nil, partialResultToken: ProgressToken? = nil) {
        self.textDocument = textDocument
        self.workDoneToken = workDoneToken
        self.partialResultToken = partialResultToken
    }
}

public struct CodeLens: Codable, Sendable {
    public var range: LSPRange
    public var command: Command?
    public var data: LSPAny?
}

public typealias CodeLensResponse = [CodeLens]?

public typealias CodeLensResolveResponse = CodeLens
