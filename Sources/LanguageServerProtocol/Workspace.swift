import Foundation

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

public struct DidChangeConfigurationParams: Codable, Hashable {
    public var settings: LSPAny

    public init(settings: LSPAny) {
        self.settings = settings
    }
}

public enum SymbolTag: Int, Codable, Hashable {
    case Deprecated = 1
}

public struct WorkspaceSymbolClientCapabilities: Codable, Hashable {
    public struct Properties: Codable, Hashable {
        public var properties: [String]
    }

    public var dynamicRegistration: Bool?
    public var symbolKind: ValueSet<SymbolKind>?
    public var tagSupport: ValueSet<SymbolTag>?
    public var resolveSupport: Properties?

    public init(dynamicRegistration: Bool?, symbolKind: [SymbolKind]?, tagSupport: [SymbolTag]?, resolveSupport: [String]?) {
        self.dynamicRegistration = dynamicRegistration
        self.symbolKind = symbolKind.map { ValueSet(valueSet: $0) }
        self.tagSupport = tagSupport.map { ValueSet(valueSet: $0) }
        self.resolveSupport = resolveSupport.map { Properties(properties: $0) }
    }
}

public struct WorkspaceSymbolOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var resolveProvider: Bool?
}

public typealias WorkspaceSymbolRegistrationOptions = WorkspaceSymbolOptions

public struct WorkspaceSymbolParams: Codable, Hashable {
    public var workDoneToken: ProgressToken?
    public var partialResultToken: ProgressToken?
    public var query: String

    public init(query: String, workDoneToken: ProgressToken? = nil, partialResultToken: ProgressToken? = nil) {
        self.workDoneToken = workDoneToken
        self.partialResultToken = partialResultToken
        self.query = query
    }
}

public struct WorkspaceSymbol: Codable, Hashable {
    public var name: String
    public var kind: SymbolKind
    public var tags: [SymbolTag]?
    public var location: TwoTypeOption<Location, TextDocumentIdentifier>?
    public var containerName: String?
}

public struct SymbolInformation: Codable, Hashable {
    public var name: String
    public var kind: SymbolKind
    public var tags: [SymbolTag]?
    public var deprecated: Bool?
    public var location: Location
    public var containerName: String?
}

public struct CreateFileOptions: Codable, Hashable {
    public let overwrite: Bool?
    public let ignoreIfExists: Bool?
}

public struct CreateFile: Codable, Hashable {
   public  let kind: String
    public let uri: DocumentUri
    public let options: CreateFileOptions?
}

public typealias RenameFileOptions = CreateFileOptions

public struct RenameFile: Codable, Hashable {
    public let kind: String
    public let oldUri: DocumentUri
    public let newUri: DocumentUri
    public let options: RenameFileOptions
}

public struct DeleteFileOptions: Codable, Hashable {
    public let recursive: Bool?
    public let ignoreIfNotExists: Bool?
}

public struct DeleteFile: Codable, Hashable {
    public let kind: String
    public let uri: DocumentUri
    public let options: DeleteFileOptions
}

public struct TextDocumentEdit: Codable, Hashable {
    public let textDocument: VersionedTextDocumentIdentifier
    public let edits: [TextEdit]
}

public enum WorkspaceEditDocumentChange: Codable, Hashable {
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

public struct WorkspaceEdit: Codable, Hashable {
    public let changes: [DocumentUri : [TextEdit]]?
    public let documentChanges: [WorkspaceEditDocumentChange]?
}
