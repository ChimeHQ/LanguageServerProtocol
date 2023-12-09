import Foundation

extension Registration {
	public var requestMethod: ClientRequest.Method? {
		return ClientRequest.Method(rawValue: method)
	}

	public var notificationMethod: ClientNotification.Method? {
		return ClientNotification.Method(rawValue: method)
	}
}

extension Unregistration {
	public var requestMethod: ClientRequest.Method? {
		return ClientRequest.Method(rawValue: method)
	}

	public var notificationMethod: ClientNotification.Method? {
		return ClientNotification.Method(rawValue: method)
	}
}

extension ServerCapabilities {
	public mutating func applyRegistrations(_ registrations: [Registration]) throws {
		try registrations.forEach({ try applyRegistration($0) })
	}

	public mutating func applyRegistration(_ registration: Registration) throws {
		switch registration.requestMethod {
		case .textDocumentSemanticTokens:
			let data = try JSONEncoder().encode(registration.registerOptions)
			let options = try JSONDecoder().decode(
				TwoTypeOption<SemanticTokensOptions, SemanticTokensRegistrationOptions>.self,
				from: data)

			self.semanticTokensProvider = options
			return
		case .textDocumentCompletion:
			let data = try JSONEncoder().encode(registration.registerOptions)
			let options = try JSONDecoder().decode(CompletionOptions.self, from: data)

			self.completionProvider = options
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

	public mutating func applyUnregistrations(_ unregistrations: [Unregistration]) throws {
		try unregistrations.forEach({ try applyUnregistration($0) })
	}

	public mutating func applyUnregistration(_ unregistration: Unregistration) throws {
		switch unregistration.requestMethod {
		case .textDocumentSemanticTokens:
			self.semanticTokensProvider = nil
			return
		case .textDocumentCompletion:
			self.completionProvider = nil
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

extension TwoTypeOption where T == TextDocumentSyncOptions, U == TextDocumentSyncKind {
	public var effectiveOptions: TextDocumentSyncOptions {
		switch self {
		case .optionA(let value):
			return value
		case .optionB(let changeKind):
			return TextDocumentSyncOptions(
				openClose: false, change: changeKind, willSave: false, willSaveWaitUntil: false,
				save: nil)
		}
	}
}

extension TwoTypeOption where T == SemanticTokensOptions, U == SemanticTokensRegistrationOptions {
	public var effectiveOptions: SemanticTokensOptions {
		switch self {
		case .optionA(let options):
			return options
		case .optionB(let registrationOptions):
			return SemanticTokensOptions(
				workDoneProgress: registrationOptions.workDoneProgress,
				legend: registrationOptions.legend,
				range: registrationOptions.range,
				full: registrationOptions.full)
		}
	}
}

extension SemanticTokensClientCapabilities.Requests.RangeOption {
	public var supported: Bool {
		switch self {
		case .optionA(let value):
			return value
		case .optionB(_):
			return true
		}
	}
}

extension SemanticTokensClientCapabilities.Requests.FullOption {
	public var supported: Bool {
		switch self {
		case .optionA(let value):
			return value
		case .optionB(_):
			return true
		}
	}

	public var deltaSupported: Bool {
		switch self {
		case .optionA(_):
			return false
		case .optionB(let full):
			return full.delta ?? false
		}
	}
}
