import Foundation

/// Sequence that reads data framed by the LSP base protocol specification.
struct AsyncMessageFramingSequence<Base>: AsyncSequence
where Base: AsyncSequence, Base.Element == UInt8 {
	public typealias Element = Data

	public struct AsyncIterator: AsyncIteratorProtocol {
		private enum State {
			case buffering
			case expectingCR
		}

		private let linefeed: UInt8 = Character("\r").asciiValue!
		private let newline: UInt8 = Character("\n").asciiValue!

		private var iterator: Base.AsyncIterator

		public init(base: Base) {
			self.iterator = base.makeAsyncIterator()
		}

		private mutating func nextByte() async throws -> UInt8? {
			try await iterator.next()
		}

		private mutating func nextField() async throws -> String? {
			var data = Data()
			var waitingForCR = false

			while let byte = try await nextByte() {
				switch (byte, waitingForCR) {
				case (newline, true):
					// done!
					return String(decoding: data, as: Unicode.ASCII.self)
				case (linefeed, false):
					waitingForCR = true
				case (newline, false):
					throw MessageFramingError.malformedData
				case (_, false):
					data.append(byte)
				case (_, true):
					throw MessageFramingError.malformedData
				}
			}

			return nil
		}

		public mutating func next() async throws -> Data? {
			// extract the headers
			var headers = [String: String]()

			while let field = try await nextField() {
				if field.isEmpty {
					break
				}

				let (name, value) = try MessageFraming.readHeader(field)
				headers[name] = value
			}

			if headers.isEmpty {
				return nil
			}

			// then use them to read the content
			guard var length = Int(headers["Content-Length"] ?? "") else {
				throw MessageFramingError.contentLengthMissing
			}

			var content = Data(capacity: length)
			while length > 0, let byte = try await nextByte() {
				content.append(byte)
				length -= 1
			}

			return content
		}
	}

	private let base: Base

	public init(base: Base) {
		self.base = base
	}

	public func makeAsyncIterator() -> AsyncIterator {
		AsyncIterator(base: base)
	}
}
