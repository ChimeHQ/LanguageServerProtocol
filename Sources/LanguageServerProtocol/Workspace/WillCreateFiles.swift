import Foundation

public enum FileOperationPatternKind: String, Codable, Hashable, Sendable {
	case file = "file"
	case folder = "folder"
}

public struct FileOperationPatternOptions: Codable, Hashable, Sendable {
	public var ignoreCase: Bool?

	public init(ignoreCase: Bool? = nil) {
		self.ignoreCase = ignoreCase
	}
}

public struct FileOperationPattern: Codable, Hashable, Sendable {
	public let glob: String
	public let matches: FileOperationPatternKind?
	public let options: FileOperationPatternOptions?

	public init(
		glob: String, matches: FileOperationPatternKind?, options: FileOperationPatternOptions?
	) {
		self.glob = glob
		self.matches = matches
		self.options = options
	}
}

public struct FileOperationFilter: Codable, Hashable, Sendable {
	public var scheme: String?
	public var pattern: FileOperationPattern

	public init(scheme: String? = nil, pattern: FileOperationPattern) {
		self.scheme = scheme
		self.pattern = pattern
	}
}

public struct FileOperationRegistrationOptions: Codable, Hashable, Sendable {
	public var filters: [FileOperationFilter]

	public init(filters: [FileOperationFilter]) {
		self.filters = filters
	}
}

public struct CreateFilesParams: Codable, Hashable, Sendable {
	public var files: [FileCreate]

	public init(files: [FileCreate]) {
		self.files = files
	}
}

public struct FileCreate: Codable, Hashable, Sendable {
	public var uri: String

	public init(uri: String) {
		self.uri = uri
	}
}

public typealias WorkspaceWillCreateFilesResponse = WorkspaceEdit?
