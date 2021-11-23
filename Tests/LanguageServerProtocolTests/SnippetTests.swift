import XCTest
@testable import LanguageServerProtocol

final class SnippetTests: XCTestCase {
    func testPlainString() {
        let snippet = Snippet(value: "plain string")

        XCTAssertEqual(snippet.elementRanges, [])
    }

    func testTabstop() {
        let snippet = Snippet(value: "plain string$0")

        XCTAssertEqual(snippet.elementRanges, [NSMakeRange(12, 2)])
    }

    func testPlaceholder() {
        let snippet = Snippet(value: "placeholder ${1:foo} string")

        XCTAssertEqual(snippet.elementRanges, [NSMakeRange(12, 8)])
    }

    func testPlaceholderEmptyDefault() {
        let snippet = Snippet(value: "function(${1:})")

        XCTAssertEqual(snippet.elementRanges, [NSMakeRange(9, 5)])
    }

    func testPlaceholderWithEscapedBrace() {
        let snippet = Snippet(value: #"function(${1:a ...interface{\\}})"#)

        XCTAssertEqual(snippet.elementRanges, [NSMakeRange(9, 23)])
    }

    func testPlaceholderAndTabstop() {
        let snippet = Snippet(value: "function(${1:foo})$0")

        XCTAssertEqual(snippet.elementRanges, [NSMakeRange(9, 8), NSMakeRange(18, 2)])
    }

    func testMultiplePlaceholders() {
        let snippet = Snippet(value: "function(${1:foo}, ${2:bar})")

        XCTAssertEqual(snippet.elementRanges, [NSMakeRange(9, 8), NSMakeRange(19, 8)])
    }

    func testVariable() {
        let snippet = Snippet(value: "function($somevar)")

        XCTAssertEqual(snippet.elementRanges, [NSMakeRange(9, 8)])
    }

    func testVariableWithDefault() {
        let snippet = Snippet(value: "function(${somevar:value})")

        XCTAssertEqual(snippet.elementRanges, [NSMakeRange(9, 16)])
    }

    func testChoice() {
        let snippet = Snippet(value: "function(${1|one,two,three|})")

        XCTAssertEqual(snippet.elementRanges, [NSMakeRange(9, 19)])
    }

    func testEnumerateElements() {
        let snippet = Snippet(value: "function(${1:foo}, ${2:bar})$0")

        var elements: [Snippet.Element] = []

        snippet.enumerateElements { (element) in
            elements.append(element)
        }

        let expectedElements = [
            Snippet.Element.text("function("),
            Snippet.Element.placeholder(1, "foo"),
            Snippet.Element.text(", "),
            Snippet.Element.placeholder(2, "bar"),
            Snippet.Element.text(")"),
            Snippet.Element.tabstop(0),
        ]

        XCTAssertEqual(elements, expectedElements)
    }

    func testEnumerateElementsWithEmptyPlaceholders() {
        let snippet = Snippet(value: "function(${1:}, ${2:})")

        let elements = snippet.elements

        let expectedElements = [
            Snippet.Element.text("function("),
            Snippet.Element.placeholder(1, ""),
            Snippet.Element.text(", "),
            Snippet.Element.placeholder(2, ""),
            Snippet.Element.text(")"),
        ]

        XCTAssertEqual(elements, expectedElements)
    }

    func testEnumerateElementsWithEscapesInPlaceholders() {
        let snippet = Snippet(value: #"function(${1:a ...interface{\}})"#)

        let elements = snippet.elements

        let expectedElements = [
            Snippet.Element.text("function("),
            Snippet.Element.placeholder(1, "a ...interface{}"),
            Snippet.Element.text(")"),
        ]

        XCTAssertEqual(elements, expectedElements)
    }

    func testEnumerateElementsWithEscapeFollowingTabstop() {
        let snippet = Snippet(value: #"Thing{$0\}"#)

        let elements = snippet.elements

        let expectedElements = [
            Snippet.Element.text("Thing{"),
            Snippet.Element.tabstop(0),
            Snippet.Element.text("}"),
        ]

        XCTAssertEqual(elements, expectedElements)
    }

    func testEnumerateElementsWithChoice() {
        let snippet = Snippet(value: "function(${1:foo}, ${2|one,two,three|})$0")

        var elements: [Snippet.Element] = []

        snippet.enumerateElements { (element) in
            elements.append(element)
        }

        let expectedElements = [
            Snippet.Element.text("function("),
            Snippet.Element.placeholder(1, "foo"),
            Snippet.Element.text(", "),
            Snippet.Element.choice(2, ["one", "two", "three"]),
            Snippet.Element.text(")"),
            Snippet.Element.tabstop(0),
        ]

        XCTAssertNotEqual(elements, expectedElements, "To be fixed")
    }

    func testEnumerateMultilineSnippet() {
        let snippet = Snippet(value: "if err != nil {\n\treturn ${1:err}\n\\}")

        var elements: [Snippet.Element] = []

        snippet.enumerateElements { (element) in
            elements.append(element)
        }

        let expectedElements = [
            Snippet.Element.text("if err != nil {\n\treturn "),
            Snippet.Element.placeholder(1, "err"),
            Snippet.Element.text("\r}"),
        ]

        XCTAssertNotEqual(elements, expectedElements)
    }
}
