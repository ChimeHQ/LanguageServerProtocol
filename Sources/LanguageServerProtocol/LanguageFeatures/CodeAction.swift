import Foundation

public typealias CodeActionKind = String

extension CodeActionKind {
    public static var Empty: CodeActionKind = ""
    public static var Quickfix: CodeActionKind = "quickfix"
    public static var Refactor: CodeActionKind = "refactor"
    public static var RefactorExtract: CodeActionKind = "refactor.extract"
    public static var RefactorInline: CodeActionKind = "refactor.inline"
    public static var RefactorRewrite: CodeActionKind = "refactor.rewrite"
    public static var Source: CodeActionKind = "source"
    public static var SourceOrganizeImports: CodeActionKind = "source.organizeImports"
}

public struct CodeActionClientCapabilities: Codable, Hashable {
    public struct CodeActionLiteralSupport: Codable, Hashable {
        public var codeActionKind: ValueSet<CodeActionKind>

        public init(codeActionKind: ValueSet<CodeActionKind>) {
            self.codeActionKind = codeActionKind
        }
    }

    public struct ResolveSupport: Codable, Hashable {
        public var properties: [String]

        public init(properties: [String]) {
            self.properties = properties
        }
    }

    public var dynamicRegistration: Bool?
    public var codeActionLiteralSupport:CodeActionLiteralSupport?
    public var isPreferredSupport: Bool?
    public var disabledSupport: Bool?
    public var dataSupport: Bool?
    public var resolveSupport: Bool?
    public var honorsChangeAnnotations: Bool?

    public init(dynamicRegistration: Bool, codeActionLiteralSupport: CodeActionClientCapabilities.CodeActionLiteralSupport? = nil, isPreferredSupport: Bool? = nil, disabledSupport: Bool? = nil, dataSupport: Bool? = nil, resolveSupport: Bool? = nil, honorsChangeAnnotations: Bool? = nil) {
        self.dynamicRegistration = dynamicRegistration
        self.codeActionLiteralSupport = codeActionLiteralSupport
        self.isPreferredSupport = isPreferredSupport
        self.disabledSupport = disabledSupport
        self.dataSupport = dataSupport
        self.resolveSupport = resolveSupport
        self.honorsChangeAnnotations = honorsChangeAnnotations
    }
}

public struct CodeActionContext: Codable, Hashable {
    public let diagnostics: [Diagnostic]
    public let only: [CodeActionKind]?

    public init(diagnostics: [Diagnostic] = [], only: [CodeActionKind]? = nil) {
        self.diagnostics = diagnostics
        self.only = only
    }
}

public struct CodeActionParams: Codable, Hashable {
    public let textDocument: TextDocumentIdentifier
    public let range: LSPRange
    public let context: CodeActionContext

    public init(textDocument: TextDocumentIdentifier, range: LSPRange, context: CodeActionContext) {
        self.textDocument = textDocument
        self.range = range
        self.context = context
    }
}

public struct CodeAction: Codable, Equatable {
    public struct Disabled: Codable, Hashable {
        public var disabled: Bool
    }

    public var title: String
    public var kind: CodeActionKind?
    public var diagnostics: [Diagnostic]?
    public var isPreferred: Bool?
    public var disabled: Disabled?
    public var edit: WorkspaceEdit?
    public var command: Command?
    public var data: LSPAny
}

public typealias CodeActionResponse = [TwoTypeOption<Command, CodeAction>]?
