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
