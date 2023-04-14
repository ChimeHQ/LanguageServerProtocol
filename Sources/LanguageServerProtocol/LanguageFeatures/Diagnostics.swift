import Foundation

public struct PublishDiagnosticsClientCapabilities: Codable, Hashable, Sendable {
    public var relatedInformation: Bool?
    public var tagSupport: ValueSet<DiagnosticTag>?
    public var versionSupport: Bool?
    public var codeDescriptionSupport: Bool?
    public var dataSupport: Bool?

    public init(relatedInformation: Bool? = nil, tagSupport: ValueSet<DiagnosticTag>? = nil, versionSupport: Bool? = nil, codeDescriptionSupport: Bool? = nil, dataSupport: Bool? = nil) {
        self.relatedInformation = relatedInformation
        self.tagSupport = tagSupport
        self.versionSupport = versionSupport
        self.codeDescriptionSupport = codeDescriptionSupport
        self.dataSupport = dataSupport
    }
}

public struct DiagnosticRelatedInformation: Codable, Hashable, Sendable {
    public let location: Location
    public let message: String
}

public typealias DiagnosticCode = TwoTypeOption<Int, String>

public enum DiagnosticSeverity: Int, CaseIterable, Codable, Hashable, Sendable {
    case error = 1
    case warning = 2
    case information = 3
    case hint = 4
}

public enum DiagnosticTag: Int, CaseIterable, Codable, Hashable, Sendable {
    case unnecessary = 1
    case deprecated = 2
}

public struct Diagnostic: Codable, Hashable, Sendable {
    public let range: LSPRange
    public let severity: DiagnosticSeverity?
    public let code: DiagnosticCode?
    public let source: String?
    public let message: String
    public let tags: [DiagnosticTag]?
    public let relatedInformation: [DiagnosticRelatedInformation]?
}

public struct PublishDiagnosticsParams: Codable, Hashable, Sendable {
    public let uri: DocumentUri
    public let version: Int?
    public let diagnostics: [Diagnostic]
}
