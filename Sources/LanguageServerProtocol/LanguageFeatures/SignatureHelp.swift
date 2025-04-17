import Foundation

public struct SignatureHelpClientCapabilities: Codable, Hashable, Sendable {
	public struct SignatureInformation: Codable, Hashable, Sendable {
		public struct ParameterInformation: Codable, Hashable, Sendable {
			public var labelOffsetSupport: Bool?

			public init(labelOffsetSupport: Bool? = nil) {
				self.labelOffsetSupport = labelOffsetSupport
			}
		}

		public var documentationFormat: [MarkupKind]?
		public var parameterInformation: ParameterInformation?
		public var activeParameterSupport: Bool?

		public init(
			documentationFormat: [MarkupKind]? = nil,
			parameterInformation: ParameterInformation? = nil, activeParameterSupport: Bool? = nil
		) {
			self.documentationFormat = documentationFormat
			self.parameterInformation = parameterInformation
			self.activeParameterSupport = activeParameterSupport
		}

		public init(
			documentationFormat: [MarkupKind]? = nil, labelOffsetSupport: Bool? = nil,
			activeParameterSupport: Bool? = nil
		) {
			self.init(
				documentationFormat: documentationFormat,
				parameterInformation: ParameterInformation(labelOffsetSupport: labelOffsetSupport),
				activeParameterSupport: activeParameterSupport)
		}
	}

	public var dynamicRegistration: Bool?
	public var signatureInformation: SignatureInformation?
	public var contextSupport: Bool?

	public init(
		dynamicRegistration: Bool?,
		signatureInformation: SignatureHelpClientCapabilities.SignatureInformation?,
		contextSupport: Bool?
	) {
		self.dynamicRegistration = dynamicRegistration
		self.signatureInformation = signatureInformation
		self.contextSupport = contextSupport
	}
}

public struct ParameterInformation: Codable, Hashable, Sendable {
	public var label: TwoTypeOption<String, [UInt]>
	public var documentation: TwoTypeOption<String, MarkupContent>?

	public init(label: TwoTypeOption<String, [UInt]>, documentation: TwoTypeOption<String, MarkupContent>? = nil) {
		self.label = label
		self.documentation = documentation
	}
}

public struct SignatureInformation: Codable, Hashable, Sendable {
	public var label: String
	public var documentation: TwoTypeOption<String, MarkupContent>?
	public var parameters: [ParameterInformation]?
	public var activeParameter: UInt?

	public init(
		label: String, documentation: TwoTypeOption<String, MarkupContent>? = nil,
		parameters: [ParameterInformation]? = nil, activeParameter: UInt? = nil
	) {
		self.label = label
		self.documentation = documentation
		self.parameters = parameters
		self.activeParameter = activeParameter
	}
}

public struct SignatureHelp: Codable, Hashable, Sendable {
	public let signatures: [SignatureInformation]
	public let activeSignature: Int?
	public let activeParameter: Int?

	public init(
		signatures: [SignatureInformation], activeSignature: Int? = nil, activeParameter: Int? = nil
	) {
		self.signatures = signatures
		self.activeSignature = activeSignature
		self.activeParameter = activeParameter
	}
}

public struct SignatureHelpRegistrationOptions: Codable, Hashable, Sendable {
	public let documentSelector: DocumentSelector?
	public let triggerCharacters: [String]?

	public init(
		documentSelector: DocumentSelector? = nil,
		triggerCharacters: [String]? = nil
	) {
		self.documentSelector = documentSelector
		self.triggerCharacters = triggerCharacters
	}
}

public typealias SignatureHelpResponse = SignatureHelp?
