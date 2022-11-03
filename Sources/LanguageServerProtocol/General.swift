import Foundation
import AnyCodable

public enum Tracing: String, Codable, Hashable {
    case off
    case messages
    case verbose
}

public struct InitializeParams: Codable {
	public struct ClientInfo: Codable, Hashable, Sendable {
		public let name: String
		public let version: String?

		public init(name: String, version: String? = nil) {
			self.name = name
			self.version = version
		}
	}

    public let processId: Int?
	public let clientInfo: ClientInfo?
	public let locale: String?
    public let rootPath: String?
    public let rootUri: DocumentUri?
    public let initializationOptions: AnyCodable?
    public let capabilities: ClientCapabilities
    public let trace: Tracing?
    public let workspaceFolders: [WorkspaceFolder]?

    public init(processId: Int,
				clientInfo: ClientInfo? = nil,
				locale: String?,
				rootPath: String?,
				rootUri: DocumentUri?,
				initializationOptions: AnyCodable?,
				capabilities: ClientCapabilities,
				trace: Tracing?,
				workspaceFolders: [WorkspaceFolder]?) {
        self.processId = processId
		self.clientInfo = clientInfo
		self.locale = locale
        self.rootPath = rootPath
        self.rootUri = rootUri
        self.initializationOptions = initializationOptions
        self.capabilities = capabilities
        self.trace = trace
        self.workspaceFolders = workspaceFolders
    }
}

public struct InitializationResponse: Codable, Hashable {
    public let capabilities: ServerCapabilities
}

public struct InitializedParams: Codable, Hashable {
    public init() {
    }
}
