import XCTest
import LanguageServerProtocol
import JSONRPC

class TwoTypeOptionTests: XCTestCase {
    func testDecodingKeyMissing() throws {
        let json = """
{"jsonrpc":"2.0","result":[{"title":"Organize Imports","kind":"source.organizeImports","edit":{"documentChanges":[{"textDocument":{"version":0,"uri":"file:///.go"},"edits":[{"range":{"start":{"line":4,"character":0},"end":{"line":5,"character":0}},"newText":""}]}]}}],"id":2}
"""
        let data = try XCTUnwrap(json.data(using: .utf8))
        let option = try JSONDecoder().decode(JSONRPCResponse<CodeActionResponse>.self, from: data)

        XCTAssertNotNil(option)
    }
}
