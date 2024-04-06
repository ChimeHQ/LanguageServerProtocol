import XCTest
import LanguageServerProtocol

final class TwoTypeOptionTests: XCTestCase {
	func testDecodingKeyMissing() throws {
		// this is a CodeAction, but being very dumb, I did not fully capture what I mean by "missing key"
		let json = """
[{"title":"Organize Imports","kind":"source.organizeImports","edit":{"documentChanges":[{"textDocument":{"version":0,"uri":"file:///.go"},"edits":[{"range":{"start":{"line":4,"character":0},"end":{"line":5,"character":0}},"newText":""}]}]}}]
"""
		let data = try XCTUnwrap(json.data(using: .utf8))
		let option = try JSONDecoder().decode(CodeActionResponse.self, from: data)

		XCTAssertNotNil(option)
	}
}
