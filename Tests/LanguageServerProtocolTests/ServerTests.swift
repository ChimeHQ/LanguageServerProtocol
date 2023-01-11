import XCTest
import JSONRPC
@testable import LanguageServerProtocol

class MockServer: Server {
    var responseData: Data?

	func setHandlers(_ handlers: LanguageServerProtocol.ServerHandlers, completionHandler: @escaping (ServerError?) -> Void) {
		completionHandler(nil)
	}

    func sendNotification(_ notif: ClientNotification, completionHandler: @escaping (ServerError?) -> Void) {
        completionHandler(.missingExpectedParameter)
    }

    func sendRequest<Response>(_ request: ClientRequest, completionHandler: @escaping (ServerResult<Response>) -> Void) where Response : Decodable, Response : Encodable {
        guard let data = responseData else {
            completionHandler(.failure(.missingExpectedResult))
            return
        }

        do {
            let response = try JSONDecoder().decode(Response.self, from: data)

            completionHandler(.success(response))
        } catch {
            completionHandler(.failure(.requestDispatchFailed(error)))
        }
    }
}

final class ServerTests: XCTestCase {
    func testNonOptionalSend() throws {
        let server = MockServer()

        // nearly all requests have optional results
        let response = DocumentLink(range: .zero, target: "something", tooltip: nil, data: nil)

        server.responseData = try JSONEncoder().encode(response)

        let param = DocumentLink(range: .zero, target: nil, tooltip: nil, data: nil)

        server.documentLinkResolve(params: param) { result in
            guard case .success(let link) = result else {
                XCTFail()
                return
            }

            XCTAssertEqual(link, response)
        }
    }

    func testOptionalSend() throws {
        let server = MockServer()

        let response: CodeActionResponse = nil

        server.responseData = try JSONEncoder().encode(response)

        let params = CodeActionParams(textDocument: TextDocumentIdentifier(path: "abc"),
                                      range: .zero,
                                      context: CodeActionContext(diagnostics: [],
                                                                 only: [.SourceOrganizeImports]))

        server.codeAction(params: params) { result in
            guard case .success(nil) = result else {
                XCTFail()
                return
            }
        }
    }

	func testAsyncSendWithNoResponse() async throws {
		let server = MockServer()

		let response: String? = nil

		server.responseData = try JSONEncoder().encode(response)

		try await server.shutdown()

		// check to make sure this throws correctly
		server.responseData = nil

		do {
			try await server.shutdown()

			XCTFail()
		} catch {
			switch error {
			case ServerError.missingExpectedResult:
				break
			default:
				throw error
			}
		}
	}
}
