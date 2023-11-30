import XCTest
import LanguageServerProtocol

final class ServerTests: XCTestCase {
    func testNonOptionalSend() async throws {
        let server = MockServer()

        // nearly all requests have optional results
        let link = DocumentLink(range: .zero, target: "something", tooltip: nil, data: nil)

		try await server.sendMockResponse(link)

        let param = DocumentLink(range: .zero, target: nil, tooltip: nil, data: nil)

		let response = try await server.documentLinkResolve(params: param)

		XCTAssertEqual(link, response)
    }

    func testOptionalSend() async throws {
		let server = MockServer()

        let expectedResponse: CodeActionResponse = nil

		try await server.sendMockResponse(expectedResponse)

        let params = CodeActionParams(textDocument: TextDocumentIdentifier(path: "abc"),
                                      range: .zero,
                                      context: CodeActionContext(diagnostics: [],
                                                                 only: [.SourceOrganizeImports]))

		let response = try await server.codeAction(params: params)

		XCTAssertNil(response)
    }

	func testSendWithNoResponse() async throws {
		let server = MockServer()

		let expectedResponse: String? = nil

		try await server.sendMockResponse(expectedResponse)

		try await server.shutdown()
	}
}
