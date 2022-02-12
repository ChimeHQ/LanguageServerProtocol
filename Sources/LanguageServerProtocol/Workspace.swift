import Foundation
import SwiftLSPClient

public struct WatchKind: OptionSet, Codable, Hashable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    static let create = WatchKind(rawValue: 1)
    static let change = WatchKind(rawValue: 2)
    static let delete = WatchKind(rawValue: 4)
}

public struct FileSystemWatcher: Codable, Hashable {
    public var globPattern: String
    public var kind: WatchKind?
}

public struct DidChangeWatchedFilesRegistrationOptions: Codable, Hashable {
    public var watchers: [FileSystemWatcher]
}

public enum FileChangeType: Int, Codable, Hashable {
    case created = 1
    case changed = 2
    case deleted = 3
}

public struct FileEvent: Codable, Hashable {
    public var uri: DocumentUri
    public var type: FileChangeType

    public init(uri: DocumentUri, type: FileChangeType) {
        self.uri = uri
        self.type = type
    }
}

public struct DidChangeWatchedFilesParams: Codable, Hashable {
    public var changes: [FileEvent]

    public init(changes: [FileEvent]) {
        self.changes = changes
    }
}

public struct WorkspaceFolder: Codable, Hashable {
    public let uri: String
    public let name: String

    public init(uri: String, name: String) {
        self.uri = uri
        self.name = name
    }
}

public struct WorkspaceFoldersChangeEvent: Codable, Hashable {
    public var added: [WorkspaceFolder]
    public var removed: [WorkspaceFolder]

    public init(added: [WorkspaceFolder], removed: [WorkspaceFolder]) {
        self.added = added
        self.removed = removed
    }
}

public struct DidChangeWorkspaceFoldersParams: Codable, Hashable {
    public var event: WorkspaceFoldersChangeEvent

    public init(event: WorkspaceFoldersChangeEvent) {
        self.event = event
    }
}
