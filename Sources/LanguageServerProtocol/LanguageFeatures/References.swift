import Foundation

public typealias ReferenceClientCapabilities = DynamicRegistrationClientCapabilities

public struct ReferenceContext: Codable, Hashable {
    public let includeDeclaration: Bool

    public init(includeDeclaration: Bool) {
        self.includeDeclaration = includeDeclaration
    }
}

public struct ReferenceParams: Codable, Hashable {
    public let textDocument: TextDocumentIdentifier
    public let position: Position
    public let context: ReferenceContext

    public init(textDocument: TextDocumentIdentifier, position: Position,
                context: ReferenceContext) {
        self.textDocument = textDocument
        self.position = position
        self.context = context
    }

    public init(textDocument: TextDocumentIdentifier, position: Position, includeDeclaration: Bool = false) {
        let ctx = ReferenceContext(includeDeclaration: includeDeclaration)

        self.init(textDocument: textDocument, position: position, context: ctx)
    }
}

public typealias ReferenceResponse = [Location]?
