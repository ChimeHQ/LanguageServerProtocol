import Foundation

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

public extension TwoTypeOption where T == TextDocumentSyncOptions, U == TextDocumentSyncKind {
     var effectiveOptions: TextDocumentSyncOptions {
        switch self {
        case .optionA(let value):
            return value
        case .optionB(let changeKind):
            return TextDocumentSyncOptions(openClose: false, change: changeKind, willSave: false, willSaveWaitUntil: false, save: nil)
        }
    }
}

public extension TwoTypeOption where T == SemanticTokensOptions, U == SemanticTokensRegistrationOptions {
    var effectiveOptions: SemanticTokensOptions {
        switch self {
        case .optionA(let options):
            return options
        case .optionB(let registrationOptions):
            return SemanticTokensOptions(workDoneProgress: registrationOptions.workDoneProgress,
                                         legend: registrationOptions.legend,
                                         range: registrationOptions.range,
                                         full: registrationOptions.full)
        }
    }
}

public extension SemanticTokensClientCapabilities.Requests.RangeOption {
    var supported: Bool {
        switch self {
        case .optionA(let value):
            return value
        case .optionB(_):
            return true
        }
    }
}

public extension SemanticTokensClientCapabilities.Requests.FullOption {
    var supported: Bool {
        switch self {
        case .optionA(let value):
            return value
        case .optionB(_):
            return true
        }
    }

    var deltaSupported: Bool {
        switch self {
        case .optionA(_):
            return false
        case .optionB(let full):
            return full.delta ?? false
        }
    }
}
