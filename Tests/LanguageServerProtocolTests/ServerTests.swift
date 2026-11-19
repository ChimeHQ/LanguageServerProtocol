import XCTest
import LanguageServerProtocol
import JSONRPC

final class ServerTests: XCTestCase {
    func testNonOptionalSend() async throws {
        let server = MockServer()

        // nearly all requests have optional results
        let link = DocumentLink(range: .zero, target: "something", tooltip: nil, data: nil)

		try await server.sendMockResponse(link)

        let param = DocumentLink(range: .zero, target: nil, tooltip: nil, data: nil)

		let response = try await server.documentLinkResolve(param)

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

		let response = try await server.codeAction(params)

		XCTAssertNil(response)
    }

	func testSendWithNoResponse() async throws {
		let server = MockServer()

		let expectedResponse: String? = nil

		try await server.sendMockResponse(expectedResponse)

		try await server.shutdown()
	}

	func testShutdownResponseWithEmptyObject() async throws {
		let server = MockServer()

		let data = Data("{}".utf8)

		await server.sendMockResponse(data)

		try await server.shutdown()
	}

	func testShutdownResponseWithNull() async throws {
		let server = MockServer()

		let data = Data("null".utf8)

		await server.sendMockResponse(data)

		try await server.shutdown()
	}

	func testServerRequestPreservesJSONRPCError() async {
		let expected = AnyJSONRPCResponseError(code: -32001, message: "Folder unavailable", data: .string("workspace"))
		let response = expectation(description: "workspace folders reply")
		let request = ServerRequest.workspaceFolders { result in
			if case let .failure(error) = result {
				XCTAssertEqual(error, expected)
			} else {
				XCTFail("Expected an error reply")
			}
			response.fulfill()
		}

		await request.relyWithError(expected)
		await fulfillment(of: [response], timeout: 1)
	}

	func testServerRequestDescribesSwiftError() async {
		enum RefreshError: Error { case refreshCancelled }
		let response = expectation(description: "code lens refresh reply")
		let request = ServerRequest.workspaceCodeLensRefresh { error in
			XCTAssertEqual(error?.code, JSONRPCErrors.internalError)
			XCTAssertEqual(error?.message, "refreshCancelled")
			XCTAssertNil(error?.data)
			response.fulfill()
		}

		await request.relyWithError(RefreshError.refreshCancelled)
		await fulfillment(of: [response], timeout: 1)
	}
}
