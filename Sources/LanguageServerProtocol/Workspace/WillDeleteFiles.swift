import Foundation

public struct DeleteFilesParams: Codable, Hashable, Sendable {
	public var files: [FileDelete]

	public init(files: [FileDelete]) {
		self.files = files
	}
}

public struct FileDelete: Codable, Hashable, Sendable {
	public var uri: String

	public init(uri: String) {
		self.uri = uri
	}
}

public typealias WorkspaceWillDeleteFilesResponse = WorkspaceEdit?
