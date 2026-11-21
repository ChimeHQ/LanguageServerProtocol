import LanguageServerProtocol
import XCTest

final class LSPRangeTests: XCTestCase {
	func testAdjacentRangesDoNotIntersect() {
		let first = LSPRange(startPair: (0, 2), endPair: (1, 0))
		let second = LSPRange(startPair: (1, 0), endPair: (1, 3))

		XCTAssertFalse(first.intersects(second))
		XCTAssertFalse(second.intersects(first))
	}

	func testNestedRangesIntersect() {
		let outer = LSPRange(startPair: (0, 2), endPair: (2, 0))
		let inner = LSPRange(startPair: (1, 0), endPair: (1, 3))

		XCTAssertTrue(outer.intersects(inner))
		XCTAssertTrue(inner.intersects(outer))
	}

	func testEmptyRangeInsideAnotherRangeDoesNotIntersect() {
		let range = LSPRange(startPair: (0, 0), endPair: (0, 4))
		let empty = LSPRange(startPair: (0, 2), endPair: (0, 2))

		XCTAssertFalse(range.intersects(empty))
		XCTAssertFalse(empty.intersects(range))
	}
}
