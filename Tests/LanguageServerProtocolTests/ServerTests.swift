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

	func testServerRequestUsesFoundationFallbackForPlainError() async {
		enum RefreshError: Error { case refreshCancelled }
		let error = RefreshError.refreshCancelled
		await assertServerError(error, hasMessage: error.localizedDescription)
	}

	func testServerRequestUsesLocalizedErrorMessage() async {
		enum FolderError: LocalizedError {
			case offline
			var errorDescription: String? { "The workspace is offline." }
		}
		await assertServerError(FolderError.offline, hasMessage: "The workspace is offline.")
	}

	func testServerRequestUsesCustomNSErrorMessage() async {
		enum FolderError: CustomNSError {
			case offline

			var errorUserInfo: [String: Any] {
				[NSLocalizedDescriptionKey: "Could not reach the workspace."]
			}
		}

		await assertServerError(FolderError.offline, hasMessage: "Could not reach the workspace.")
	}

	func testServerRequestSendsOnlyNSErrorMessage() async {
		let error = NSError(domain: "Workspace", code: 1, userInfo: [
			NSLocalizedDescriptionKey: "Could not open the workspace.",
			"internalContext": "local diagnostic details",
		])
		await assertServerError(error, hasMessage: "Could not open the workspace.")
	}

	private func assertServerError(_ supplied: Error, hasMessage message: String,
		file: StaticString = #filePath, line: UInt = #line
	) async {
		let response = expectation(description: "code lens refresh reply")
		let request = ServerRequest.workspaceCodeLensRefresh { error in
			XCTAssertEqual(error?.code, JSONRPCErrors.internalError, file: file, line: line)
			XCTAssertEqual(error?.message, message, file: file, line: line)
			XCTAssertNil(error?.data, file: file, line: line)
			response.fulfill()
		}

		await request.relyWithError(supplied)
		await fulfillment(of: [response], timeout: 1)
	}
}
