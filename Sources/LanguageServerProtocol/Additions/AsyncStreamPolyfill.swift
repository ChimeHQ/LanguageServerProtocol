import Foundation

#if compiler(<5.9)

// @available(SwiftStdlib 5.1, *)
extension AsyncStream {
	/// Initializes a new ``AsyncStream`` and an ``AsyncStream/Continuation``.
	///
	/// - Parameters:
	///   - elementType: The element type of the stream.
	///   - limit: The buffering policy that the stream should use.
	/// - Returns: A tuple containing the stream and its continuation. The continuation should be passed to the
	/// producer while the stream should be passed to the consumer.
	// @backDeployed(before: SwiftStdlib 5.9)
	static func makeStream(
		of elementType: Element.Type = Element.self,
		bufferingPolicy limit: Continuation.BufferingPolicy = .unbounded
	) -> (stream: AsyncStream<Element>, continuation: AsyncStream<Element>.Continuation) {
		var continuation: AsyncStream<Element>.Continuation!
		let stream = AsyncStream<Element>(bufferingPolicy: limit) { continuation = $0 }
		return (stream: stream, continuation: continuation!)
	}
}

// @available(SwiftStdlib 5.1, *)
extension AsyncThrowingStream {
	/// Initializes a new ``AsyncThrowingStream`` and an ``AsyncThrowingStream/Continuation``.
	///
	/// - Parameters:
	///   - elementType: The element type of the stream.
	///   - failureType: The failure type of the stream.
	///   - limit: The buffering policy that the stream should use.
	/// - Returns: A tuple containing the stream and its continuation. The continuation should be passed to the
	/// producer while the stream should be passed to the consumer.
	// @backDeployed(before: SwiftStdlib 5.9)
	static func makeStream(
		of elementType: Element.Type = Element.self,
		throwing failureType: Failure.Type = Failure.self,
		bufferingPolicy limit: Continuation.BufferingPolicy = .unbounded
	) -> (stream: AsyncThrowingStream<Element, Failure>, continuation: AsyncThrowingStream<Element, Failure>.Continuation) where Failure == Error {
		var continuation: AsyncThrowingStream<Element, Failure>.Continuation!
		let stream = AsyncThrowingStream<Element, Failure>(bufferingPolicy: limit) { continuation = $0 }
		return (stream: stream, continuation: continuation!)
	}
}
#endif
