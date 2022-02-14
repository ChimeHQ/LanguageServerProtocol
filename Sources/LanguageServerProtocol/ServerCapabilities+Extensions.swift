import Foundation
import SwiftLSPClient

public extension Registration {
    var requestMethod: ClientRequest.Method? {
        return ClientRequest.Method(rawValue: method)
    }

    var notificationMethod: ClientNotification.Method? {
        return ClientNotification.Method(rawValue: method)
    }
}

public extension Unregistration {
    var requestMethod: ClientRequest.Method? {
        return ClientRequest.Method(rawValue: method)
    }

    var notificationMethod: ClientNotification.Method? {
        return ClientNotification.Method(rawValue: method)
    }
}

public extension ServerCapabilities {
    mutating func applyRegistrations(_ registrations: [Registration]) throws {
        try registrations.forEach({ try applyRegistration($0) })
    }

    mutating func applyRegistration(_ registration: Registration) throws {
        switch registration.requestMethod {
        case .textDocumentSemanticTokens:
            let data = try JSONEncoder().encode(registration.registerOptions)
            let options = try JSONDecoder().decode(TwoTypeOption<SemanticTokensOptions, SemanticTokensRegistrationOptions>.self, from: data)

            self.semanticTokensProvider = options
            return
        default:
            break
        }

        switch registration.notificationMethod {
        case .workspaceDidChangeWatchedFiles:
            break
        default:
            break
        }
    }

    mutating func applyUnregistrations(_ unregistrations: [Unregistration]) throws {
        try unregistrations.forEach({ try applyUnregistration($0) })
    }

    mutating func applyUnregistration(_ unregistration: Unregistration) throws {
        switch unregistration.requestMethod {
        case .textDocumentSemanticTokens:
            self.semanticTokensProvider = nil
            return
        default:
            break
        }

        switch unregistration.notificationMethod {
        case .workspaceDidChangeWatchedFiles:
            break
        default:
            break
        }
    }
}
