import Foundation
import AnyCodable

public typealias LSPAny = AnyCodable?

public typealias URI = String

public typealias DocumentUri = String

public typealias ProgressToken = TwoTypeOption<Int, String>

public struct CancelParams: Hashable, Codable {
    public var id: TwoTypeOption<Int, String>

    public init(id: Int) {
        self.id = .optionA(id)
    }

    public init(id: String) {
        self.id = .optionB(id)
    }
}

public struct ProgressParams: Hashable, Codable {
    public var token: ProgressToken
    public var value: LSPAny
}

public struct LogTraceParams: Hashable, Codable {
    public var string: String
    public var verbose: String?
}

public enum TraceValue: String, Hashable, Codable {
    case off
    case messages
    case verbose
}

public struct SetTraceParams: Hashable, Codable {
    public var value: TraceValue

    public init(value: TraceValue) {
        self.value = value
    }
}

public struct ValueSet<T: Hashable & Codable>: Hashable, Codable {
    public var valueSet: [T]

    public init(valueSet: [T]) {
        self.valueSet = valueSet
    }

    public init(value: T) {
        self.valueSet = [value]
    }
}

extension ValueSet: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = T

    public init(arrayLiteral elements: T...) {
        self.valueSet = elements
    }
}

public extension ValueSet where T: CaseIterable {
    static var all: ValueSet<T> {
        return ValueSet(valueSet: Array(T.allCases))
    }
}

public enum LanguageIdentifier: String, Codable, CaseIterable {
	case abap
	case windowsbat = "bat"
	case bibtex
	case clojure = "clojure"
	case coffeescript
    case c
    case cpp
	case csharp
	case css
	case diff
	case dart
	case dockerfile
	case elixir
	case erlang
	case fsharp
	case gitcommit
	case gitrebase
    case go
	case groovy
	case handlebars
	case html
	case ini
	case java
	case javascript
	case javascriptreact
    case json
	case latex
	case less
	case lua
	case makefile
	case markdown
    case objc = "objective-c"
    case objcpp = "objective-cpp"
	case perl
	case perl6
    case php
	case powershell
	case pug = "jade"
	case python
	case r
	case razor
    case ruby
    case rust
	case scss
	case sass
	case scala
	case shaderlab
	case shellscript
	case sql
    case swift
	case typescript
	case typescriptreact
	case tex
	case vb
	case xml
	case xsl
	case yaml
}

public struct DocumentFilter: Codable, Hashable {
    public let language: LanguageIdentifier?
    public let scheme: String?
    public let pattern: String?
}

public typealias DocumentSelector = [DocumentFilter]

public struct TextDocumentIdentifier {
    public var uri: DocumentUri

    public init(uri: DocumentUri) {
        self.uri = uri
    }

    public init(path: String) {
        self.uri = URL(fileURLWithPath: path).absoluteString
    }
}

extension TextDocumentIdentifier: Codable {
}

extension TextDocumentIdentifier: Hashable {
}

extension TextDocumentIdentifier: CustomStringConvertible {
    public var description: String {
        return uri.description
    }
}
