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
}

public struct SignatureInformation: Codable, Hashable, Sendable {
	public var label: String
	public var documentation: TwoTypeOption<String, MarkupContent>?
	public var parameters: [ParameterInformation]?
	public var activeParameter: UInt?
}

public struct SignatureHelp: Codable, Hashable, Sendable {
	public let signatures: [SignatureInformation]
	public let activeSignature: Int?
	public let activeParameter: Int?
}

public struct SignatureHelpRegistrationOptions: Codable, Hashable, Sendable {
	public let documentSelector: DocumentSelector?
	public let triggerCharacters: [String]?
}

public typealias SignatureHelpResponse = SignatureHelp?
