import Foundation

public struct RenameFilesParams: Codable, Hashable {
    public var files: [FileRename]

    public init(files: [FileRename]) {
        self.files = files
    }
}

public struct FileRename: Codable, Hashable {
    public var oldUri: String
    public var newUri: String

    public init(oldUri: String, newUri: String) {
        self.oldUri = oldUri
        self.newUri = newUri
    }
}

public typealias WorkspaceWillRenameFilesResponse = WorkspaceEdit?
