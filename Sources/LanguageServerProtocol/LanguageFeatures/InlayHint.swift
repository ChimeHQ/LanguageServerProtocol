import Foundation

public struct InlayHintClientCapabilities: Codable, Hashable, Sendable {
	public struct ResolveSupport: Codable, Hashable, Sendable {
		public var properties: [String]

		public init(properties: [String]) {
			self.properties = properties
		}
	}

	public var dynamicRegistration: Bool?
	public var resolveSupport: ResolveSupport?

	public init(dynamicRegistration: Bool?, resolveSupport: ResolveSupport? = nil) {
		self.dynamicRegistration = dynamicRegistration
	}
}

public typealias InlayHintOptions = WorkDoneProgressOptions

public struct InlayHintRegistrationOptions: Codable, Hashable, Sendable {
	public var documentSelector: DocumentSelector?
	public var workDoneProgress: Bool?
	public var id: String?

	public init(documentSelector: DocumentSelector? = nil, workDoneProgress: Bool? = nil, id: String? = nil) {
		self.documentSelector = documentSelector
		self.workDoneProgress = workDoneProgress
		self.id = id
	}
}

public struct InlayHintWorkspaceClientCapabilities: Codable, Hashable, Sendable {
	public var refreshSupport: Bool?

	public init(refreshSupport: Bool? = nil) {
		self.refreshSupport = refreshSupport
	}
}

public struct InlayHintParams: Codable, Hashable, Sendable {
	public var workDoneToken: ProgressToken?
	public var textDocument: TextDocumentIdentifier
	public var range: LSPRange

	public init(workDoneToken: ProgressToken? = nil, textDocument: TextDocumentIdentifier, range: LSPRange) {
		self.workDoneToken = workDoneToken
		self.textDocument = textDocument
		self.range = range
	}
}

public struct InlayHintLabelPart: Codable, Hashable, Sendable {
	public var value: String
	public var tooltop: TwoTypeOption<String, MarkupContent>?
	public var location: Location?
	public var command: Command?

	public init(value: String, tooltop: TwoTypeOption<String, MarkupContent>? = nil, location: Location? = nil, command: Command? = nil) {
		self.value = value
		self.tooltop = tooltop
		self.location = location
		self.command = command
	}
}

public enum InlayHintKind: Int, Codable, Hashable, Sendable {
	case type = 1
	case parameter = 2
}

public struct InlayHint: Codable, Hashable, Sendable {
	public var position: Position
	public var label: TwoTypeOption<String, [InlayHintLabelPart]>
	public var kind: InlayHintKind?
	public var textEdits: [TextEdit]?
	public var tooltip: TwoTypeOption<String, MarkupContent>?
	public var paddingLeft: Bool?
	public var paddingRight: Bool?
	public var data: LSPAny?

	public init(
		position: Position,
		label: TwoTypeOption<String, [InlayHintLabelPart]>,
		kind: InlayHintKind? = nil,
		textEdits: [TextEdit]? = nil,
		tooltip: TwoTypeOption<String, MarkupContent>? = nil,
		paddingLeft: Bool? = nil,
		paddingRight: Bool? = nil,
		data: LSPAny? = nil
	) {
		self.position = position
		self.label = label
		self.kind = kind
		self.textEdits = textEdits
		self.tooltip = tooltip
		self.paddingLeft = paddingLeft
		self.paddingRight = paddingRight
		self.data = data
	}
}

public typealias InlayHintResponse = [InlayHint]?
