import Foundation

/// Converts a sequence of Data objects into a sequence of bytes.
struct AsyncByteSequence<Base>: AsyncSequence where Base: AsyncSequence, Base.Element == Data {
	public typealias Element = UInt8

	public struct AsyncIterator: AsyncIteratorProtocol {
		private enum State {
			case idle
			case enumerating(Data, Data.Index)
		}

		private var iterator: Base.AsyncIterator
		private var currentChunk: Data?
		private var index: Int = 0

		public init(base: Base) {
			self.iterator = base.makeAsyncIterator()
		}

		private mutating func currentData() async throws -> Data? {
			if let data = currentChunk, index < data.endIndex {
				return data
			}

			self.index = 0

			let data = try await iterator.next()

			self.currentChunk = data

			return data
		}

		public mutating func next() async throws -> UInt8? {
			if Task.isCancelled {
				return nil
			}

			guard let data = try await currentData() else {
				return nil
			}

			let byte = data[index]

			index += 1

			return byte
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
