import XCTest
@testable import LanguageServerProtocol

struct AsyncDataSequence : AsyncSequence {
	typealias Element = UInt8

	struct AsyncIterator : AsyncIteratorProtocol {
		private var index: Int = 0
		private let data: Data

		init(data: Data) {
			self.data = data
		}

		mutating func next() async -> UInt8? {
			if Task.isCancelled {
				return nil
			}

			if index >= data.endIndex {
				return nil
			}

			let value = data[index]

			index += 1

			return value
		}
	}

	private let data: Data

	init(data: Data) {
		self.data = data
	}

	func makeAsyncIterator() -> AsyncIterator {
		AsyncIterator(data: data)
	}
}

final class AsyncMessageFramingSequenceTests: XCTestCase {
	func testBasicMessageDecode() async throws {
		let content = "{\"jsonrpc\":\"2.0\",\"params\":\"Something\"}"
		let message = "Content-Length: \(content.utf8.count)\r\n\r\n\(content)"
		let sequence = AsyncDataSequence(data: Data(message.utf8))

		let contentSequence = AsyncMessageFramingSequence(base: sequence)
		var iterator = contentSequence.makeAsyncIterator()

		let data = try await iterator.next()
		let value = data.flatMap { String(decoding: $0, as: UTF8.self) }

		XCTAssertEqual(value, content)

		let ending = try await iterator.next()
		XCTAssertNil(ending)
	}

	func testMultiHeaderMessage() async throws {
		let content = "{\"jsonrpc\":\"2.0\",\"params\":\"Something\"}"
		let header1 = "Content-Length: \(content.utf8.count)\r\n"
		let header2 = "Another-Header: Something\r\n"
		let header3 = "And-Another: third\r\n"
		let message = header1 + header2 + header3 + "\r\n" + content
		let sequence = AsyncDataSequence(data: Data(message.utf8))

		let contentSequence = AsyncMessageFramingSequence(base: sequence)
		var iterator = contentSequence.makeAsyncIterator()

		let data = try await iterator.next()
		let value = data.flatMap { String(decoding: $0, as: UTF8.self) }

		XCTAssertEqual(value, content)

		let ending = try await iterator.next()
		XCTAssertNil(ending)
	}

	func testFrameMessage() async throws {
		let content = Data("abc".utf8)
		let data = MessageFraming.frame(content)

		XCTAssertEqual(data, Data("Content-Length: 3\r\n\r\nabc".utf8))
	}
}
