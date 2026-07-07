import XCTest
import LanguageServerProtocol

final class CompletionItemTests: XCTestCase {
	func testDecodingLabelDetails() throws {
		// a textDocument/completion response item shaped per the LSP 3.17 spec
		let json = """
            {"label":"map","labelDetails":{"detail":"(transform: (Element) -> T)","description":"[T]"},"kind":3,"insertText":"map"}
            """
		let data = try XCTUnwrap(json.data(using: .utf8))
		let item = try JSONDecoder().decode(CompletionItem.self, from: data)

		XCTAssertEqual(item.labelDetails, CompletionItemLabelDetails(detail: "(transform: (Element) -> T)", description: "[T]"))
	}
}
