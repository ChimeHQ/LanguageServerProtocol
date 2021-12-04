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
