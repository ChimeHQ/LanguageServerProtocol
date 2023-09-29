import Foundation

public struct WatchKind: OptionSet, Codable, Hashable, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let create = WatchKind(rawValue: 1)
    public static let change = WatchKind(rawValue: 2)
    public static let delete = WatchKind(rawValue: 4)

    public static let all: WatchKind = [.create, .change, .delete]
}

public struct FileSystemWatcher: Codable, Hashable, Sendable {
    public var globPattern: String
    public var kind: WatchKind?

    public init(globPattern: String, kind: WatchKind? = nil) {
        self.globPattern = globPattern
        self.kind = kind
    }
}

public struct DidChangeWatchedFilesRegistrationOptions: Codable, Hashable, Sendable {
    public var watchers: [FileSystemWatcher]
}

public enum FileChangeType: Int, Codable, Hashable, Sendable {
    case created = 1
    case changed = 2
    case deleted = 3
}

public struct FileEvent: Codable, Hashable, Sendable {
    public var uri: DocumentUri
    public var type: FileChangeType

    public init(uri: DocumentUri, type: FileChangeType) {
        self.uri = uri
        self.type = type
    }
}

public struct DidChangeWatchedFilesParams: Codable, Hashable, Sendable {
    public var changes: [FileEvent]

    public init(changes: [FileEvent]) {
        self.changes = changes
    }
}

public struct WorkspaceFolder: Codable, Hashable, Sendable {
    public let uri: String
    public let name: String

    public init(uri: String, name: String) {
        self.uri = uri
        self.name = name
    }
}

public struct WorkspaceFoldersChangeEvent: Codable, Hashable, Sendable {
    public var added: [WorkspaceFolder]
    public var removed: [WorkspaceFolder]

    public init(added: [WorkspaceFolder], removed: [WorkspaceFolder]) {
        self.added = added
        self.removed = removed
    }
}

public struct DidChangeWorkspaceFoldersParams: Codable, Hashable, Sendable {
    public var event: WorkspaceFoldersChangeEvent

    public init(event: WorkspaceFoldersChangeEvent) {
        self.event = event
    }
}

public struct DidChangeConfigurationParams: Codable, Hashable, Sendable {
    public var settings: LSPAny?

    public init(settings: LSPAny) {
        self.settings = settings
    }
}

public enum SymbolTag: Int, Codable, Hashable, CaseIterable, Sendable {
    case Deprecated = 1
}

public struct SymbolInformation: Codable, Hashable, Sendable {
    public let name: String
    public let kind: SymbolKind
    public let tags: [SymbolTag]?
    public let deprecated: Bool?
    public let location: Location
    public let containerName: String?

	public init(name: String, kind: SymbolKind, tags: [SymbolTag]? = nil, deprecated: Bool? = nil, location: Location, containerName: String? = nil) {
		self.name = name
		self.kind = kind
		self.tags = tags
		self.deprecated = deprecated
		self.location = location
		self.containerName = containerName
	}
}

public struct CreateFileOptions: Codable, Hashable, Sendable {
    public let overwrite: Bool?
    public let ignoreIfExists: Bool?
}

public struct CreateFile: Codable, Hashable, Sendable {
   public  let kind: String
    public let uri: DocumentUri
    public let options: CreateFileOptions?
}

public typealias RenameFileOptions = CreateFileOptions

public struct RenameFile: Codable, Hashable, Sendable {
    public let kind: String
    public let oldUri: DocumentUri
    public let newUri: DocumentUri
    public let options: RenameFileOptions
}

public struct DeleteFileOptions: Codable, Hashable, Sendable {
    public let recursive: Bool?
    public let ignoreIfNotExists: Bool?
}

public struct DeleteFile: Codable, Hashable, Sendable {
    public let kind: String
    public let uri: DocumentUri
    public let options: DeleteFileOptions
}

public struct TextDocumentEdit: Codable, Hashable, Sendable {
    public let textDocument: VersionedTextDocumentIdentifier
    public let edits: [TextEdit]
}

public enum WorkspaceEditDocumentChange: Codable, Hashable, Sendable {
    case textDocumentEdit(TextDocumentEdit)
    case createFile(CreateFile)
    case renameFile(RenameFile)
    case deleteFile(DeleteFile)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(TextDocumentEdit.self) {
            self = .textDocumentEdit(value)
        } else if let value = try? container.decode(CreateFile.self) {
            self = .createFile(value)
        } else if let value = try? container.decode(RenameFile.self) {
            self = .renameFile(value)
        } else {
            let value = try container.decode(DeleteFile.self)
            self = .deleteFile(value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .textDocumentEdit(let value):
            try container.encode(value)
        case .createFile(let value):
            try container.encode(value)
        case .renameFile(let value):
            try container.encode(value)
        case .deleteFile(let value):
            try container.encode(value)
        }
    }
}

public struct WorkspaceEdit: Codable, Hashable, Sendable {
    public let changes: [DocumentUri : [TextEdit]]?
    public let documentChanges: [WorkspaceEditDocumentChange]?
}
