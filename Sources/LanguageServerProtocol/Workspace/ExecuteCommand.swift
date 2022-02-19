import Foundation

public typealias ExecuteCommandClientCapabilities = DynamicRegistrationClientCapabilities

public struct ExecuteCommandOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var commands: [String]

    public init(workDoneProgress: Bool? = nil, commands: [String]) {
        self.workDoneProgress = workDoneProgress
        self.commands = commands
    }
}

public typealias ExecuteCommandRegistrationOptions = ExecuteCommandOptions

public struct ExecuteCommandParams: Codable, Hashable {
    public var workDoneToken: ProgressToken?
    public var command: String
    public var arguments: [LSPAny]?

    public init(workDoneToken: ProgressToken? = nil, command: String, arguments: [LSPAny]? = nil) {
        self.workDoneToken = workDoneToken
        self.command = command
        self.arguments = arguments
    }
}

public typealias ExecuteCommandResponse = LSPAny
