import XCTest
import LanguageServerProtocol

final class CallHierarchyTests: XCTestCase {
	private var itemJSON: [String: Any] {
		let range = ["start": ["line": 1, "character": 0], "end": ["line": 1, "character": 9]]
		return ["name": "oldMethod", "kind": 6, "uri": "file:///main.swift", "range": range, "selectionRange": range]
	}

	func testDeprecatedTagSurvivesCallHierarchyRequests() throws {
		var item = itemJSON
		item["tags"] = [1]
		let result = try JSONSerialization.data(withJSONObject: [item])
		let response = try JSONDecoder().decode(CallHierarchyPrepareResponse.self, from: result)
		let prepared = try XCTUnwrap(response?.first)
		XCTAssertEqual(prepared.tag, [.Deprecated])

		let params = CallHierarchyIncomingCallsParams(item: prepared)
		let data = try JSONEncoder().encode(params)
		let encoded = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
		let encodedItem = try XCTUnwrap(encoded["item"] as? [String: Any])
		XCTAssertEqual(encodedItem["tags"] as? [Int], [1])
		XCTAssertNil(encodedItem["tag"])
	}

	func testDecodesLegacyTagAndPrefersCanonicalTags() throws {
		var item = itemJSON
		let untagged = try JSONSerialization.data(withJSONObject: item)
		XCTAssertNil(try JSONDecoder().decode(CallHierarchyItem.self, from: untagged).tag)
		item["tag"] = [1]
		let legacy = try JSONSerialization.data(withJSONObject: item)
		XCTAssertEqual(try JSONDecoder().decode(CallHierarchyItem.self, from: legacy).tag, [.Deprecated])

		item["tags"] = []
		let both = try JSONSerialization.data(withJSONObject: item)
		XCTAssertEqual(try JSONDecoder().decode(CallHierarchyItem.self, from: both).tag, [])
	}
}
