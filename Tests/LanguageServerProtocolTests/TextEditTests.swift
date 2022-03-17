import XCTest
@testable import LanguageServerProtocol

final class TextEditTests: XCTestCase {
    func testMakeApplicableFiltersNoops() {
        let edits = [
            TextEdit(range: LSPRange(startPair: (0,0), endPair: (0,0)), newText: ""),
        ]

        let expected: [TextEdit] = []

        XCTAssertEqual(TextEdit.makeApplicable(edits), expected)
    }

    func testMakeApplicableSorts() {
        let edits = [
            TextEdit(range: LSPRange(startPair: (0,0), endPair: (0,0)), newText: "abc"),
            TextEdit(range: LSPRange(startPair: (2,1), endPair: (2,2)), newText: ""),
            TextEdit(range: LSPRange(startPair: (1,0), endPair: (1,0)), newText: "def"),
        ]

        let expected: [TextEdit] = [
            edits[1],
            edits[2],
            edits[0]
        ]

        XCTAssertEqual(TextEdit.makeApplicable(edits), expected)
    }

    func testMakeApplicableConsolidatesAdjacentInserts() {
        let edits = [
            TextEdit(range: LSPRange(startPair: (0,0), endPair: (0,0)), newText: "abc"),
            TextEdit(range: LSPRange(startPair: (0,0), endPair: (0,0)), newText: "def"),
        ]

        let expected: [TextEdit] = [
            TextEdit(range: LSPRange(startPair: (0,0), endPair: (0,0)), newText: "abcdef"),
        ]

        XCTAssertEqual(TextEdit.makeApplicable(edits), expected)
    }
}
