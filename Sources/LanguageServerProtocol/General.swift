import Foundation

public enum Tracing: String, Codable, Hashable, Sendable {
	case off
	case messages
	case verbose
}

public struct InitializeParams: Codable, Hashable, Sendable {
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
	public let initializationOptions: LSPAny?
	public let capabilities: ClientCapabilities
	public let trace: Tracing?
	public let workspaceFolders: [WorkspaceFolder]?

	public init(
		processId: Int,
		clientInfo: ClientInfo? = nil,
		locale: String?,
		rootPath: String?,
		rootUri: DocumentUri?,
		initializationOptions: LSPAny?,
		capabilities: ClientCapabilities,
		trace: Tracing?,
		workspaceFolders: [WorkspaceFolder]?
	) {
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

public struct ServerInfo: Codable, Hashable, Sendable {
	/**
	 * The name of the server as defined by the server.
	 */
	public var name: String

	/**
	 * The server's version as defined by the server.
	 */
	public var version: String?

	public init(name: String, version: String?) {
		self.name = name
		self.version = version
	}
}

public struct InitializationResponse: Codable, Hashable, Sendable {
	public let capabilities: ServerCapabilities
	public let serverInfo: ServerInfo?

	public init(capabilities: ServerCapabilities, serverInfo: ServerInfo?) {
		self.capabilities = capabilities
		self.serverInfo = serverInfo
	}
}

public struct InitializedParams: Codable, Hashable, Sendable {
	public init() {
	}
}
