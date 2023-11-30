import Foundation
import JSONRPC

extension DataChannel {
	/// Wrap http message framing on an existing data channel
	public func withMessageFraming() -> DataChannel {
		let writeHandler: DataChannel.WriteHandler = { data in
			let data = MessageFraming.frame(data)

			try await self.writeHandler(data)
		}

		let (stream, continuation) = DataSequence.makeStream()

		Task {
			let byteStream = AsyncByteSequence(base: dataSequence)
			let framedData = AsyncMessageFramingSequence(base: byteStream)

			for try await data in framedData {
				continuation.yield(data)
			}

			continuation.finish()
		}

		return DataChannel(writeHandler: writeHandler,
						   dataSequence: stream)
	}
}
