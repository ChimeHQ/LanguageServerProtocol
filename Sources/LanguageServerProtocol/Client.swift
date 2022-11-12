import Foundation

public struct Registration: Codable {
    public var id: String
    public var method: String
    public var registerOptions: LSPAny?
}

extension Registration {
    var registerOptionsData: Data? {
        return try? JSONEncoder().encode(registerOptions)
    }

    func reintrepretOptions<T: Decodable>(_ type: T.Type) throws -> T {
        let data = try JSONEncoder().encode(registerOptions)

        return try JSONDecoder().decode(type.self, from: data)
    }

    func decodeServerRegistration() throws -> ServerRegistration {
        guard let regMethod = ServerRegistration.Method(rawValue: method) else {
            throw ServerError.unhandledMethod(method)
        }

        switch regMethod {
        case .workspaceDidChangeWatchedFiles:
            let options = try reintrepretOptions(DidChangeWatchedFilesRegistrationOptions.self)

            return .workspaceDidChangeWatchedFiles(options)
        case .workspaceDidChangeConfiguration:
            return .workspaceDidChangeConfiguration
        case .workspaceDidChangeWorkspaceFolders:
            return .workspaceDidChangeWorkspaceFolders
        case .textDocumentSemanticTokens:
            let options = try reintrepretOptions(SemanticTokensRegistrationOptions.self)

            return .textDocumentSemanticTokens(options)

        }
    }

    public var serverRegistration: ServerRegistration? {
        return try? decodeServerRegistration()
    }
}

public struct RegistrationParams: Codable {
    public var registrations: [Registration]

    public var serverRegistrations: [ServerRegistration] {
        return registrations.compactMap({ $0.serverRegistration })
    }
}

public struct Unregistration: Codable {
    public var id: String
    public var method: String
}

public struct UnregistrationParams: Codable {
    public var unregistrations: [Unregistration]
}
