import Foundation

public struct RenameFilesParams: Codable, Hashable, Sendable {
	public var files: [FileRename]

	public init(files: [FileRename]) {
		self.files = files
	}
}

public struct FileRename: Codable, Hashable, Sendable {
	public var oldUri: String
	public var newUri: String

	public init(oldUri: String, newUri: String) {
		self.oldUri = oldUri
		self.newUri = newUri
	}
}

public typealias WorkspaceWillRenameFilesResponse = WorkspaceEdit?
