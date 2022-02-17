import Foundation
import AnyCodable

public enum Tracing: String, Codable, Hashable {
    case off
    case messages
    case verbose
}

public struct InitializeParams: Codable {
    public let processId: Int
    public let rootPath: String?
    public let rootURI: DocumentUri?
    public let initializationOptions: AnyCodable?
    public let capabilities: ClientCapabilities
    public let trace: Tracing?
    public let workspaceFolders: [WorkspaceFolder]?

    public init(processId: Int, rootPath: String?, rootURI: DocumentUri?, initializationOptions: AnyCodable?, capabilities: ClientCapabilities, trace: Tracing?, workspaceFolders: [WorkspaceFolder]?) {
        self.processId = processId
        self.rootPath = rootPath
        self.rootURI = rootURI
        self.initializationOptions = initializationOptions
        self.capabilities = capabilities
        self.trace = trace
        self.workspaceFolders = workspaceFolders
    }
}

public struct InitializationResponse: Codable, Hashable {
    public let capabilities: ServerCapabilities
}
