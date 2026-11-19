import XCTest
import LanguageServerProtocol

final class CompletionItemTests: XCTestCase {
	func testInitializeWithUnspecifiedCompletionItemKinds() throws {
		let json = #"{"capabilities":{"textDocument":{"completion":{"completionItemKind":{},"contextSupport":true}}}}"#
		let params = try JSONDecoder().decode(InitializeParams.self, from: Data(json.utf8))
		let completion = try XCTUnwrap(params.capabilities.textDocument?.completion)
		XCTAssertNil(completion.completionItemKind)
		XCTAssertEqual(completion.contextSupport, true)
	}

	func testRoundTripCompletionCapabilities() throws {
		for kinds: ValueSet<CompletionItemKind>? in [nil, [], [.text, .method]] {
			let capabilities = CompletionClientCapabilities(
				dynamicRegistration: true, completionItem: .init(snippetSupport: true),
				completionItemKind: kinds, contextSupport: false, insertTextMode: .asIs,
				completionList: .init(itemDefaults: ["editRange"]))
			let data = try JSONEncoder().encode(capabilities)
			XCTAssertEqual(try JSONDecoder().decode(CompletionClientCapabilities.self, from: data), capabilities)
		}
	}

	func testMalformedCompletionKindsAreRejected() {
		let json = #"{"completionItemKind":{"valueSet":"text"}}"#
		XCTAssertThrowsError(try JSONDecoder().decode(CompletionClientCapabilities.self, from: Data(json.utf8)))
	}

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
