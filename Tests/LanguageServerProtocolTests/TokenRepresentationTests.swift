import XCTest
@testable import LanguageServerProtocol

// All based on gopls and this Go source file:

// package main
//
// import "fmt"
// import "log"
//
// func main() {
// 	fmt.Println("hello world")
// }

final class TokenRepresentationTests: XCTestCase {
	func testDataDecode() {
		let tokenTypes = ["namespace", "type", "class", "enum", "interface", "struct", "typeParameter", "parameter", "variable", "property", "enumMember", "event", "function", "method", "macro", "keyword", "modifier", "comment", "string", "number", "regexp", "operator"]
		let tokenModifiers = ["declaration", "definition", "readonly", "static", "deprecated", "abstract", "async", "modification", "documentation", "defaultLibrary"]
		let legend = SemanticTokensLegend(tokenTypes: tokenTypes, tokenModifiers: tokenModifiers)
		let rep = TokenRepresentation(legend: legend)

		let codedData: [UInt32] = [0,0,7,15,0,0,8,4,0,0,2,0,6,15,0,0,8,3,0,0,1,0,6,15,0,0,8,3,0,0,2,0,4,15,0,0,5,4,12,2,1,4,3,0,0,0,4,7,12,0,0,8,13,18,0]

		_ = rep.applyData(codedData)

		let range = LSPRange(startPair: (0, 0), endPair: (7, 1))
		let tokens = rep.decodeTokens(in: range)

		let expectedTokens = [
			Token(range: LSPRange(startPair: (0, 0), endPair: (0, 7)), tokenType: "keyword"),
			Token(range: LSPRange(startPair: (0, 8), endPair: (0, 12)), tokenType: "namespace"),
			Token(range: LSPRange(startPair: (2, 0), endPair: (2, 6)), tokenType: "keyword"),
			Token(range: LSPRange(startPair: (2, 8), endPair: (2, 11)), tokenType: "namespace"),
			Token(range: LSPRange(startPair: (3, 0), endPair: (3, 6)), tokenType: "keyword"),
			Token(range: LSPRange(startPair: (3, 8), endPair: (3, 11)), tokenType: "namespace"),
			Token(range: LSPRange(startPair: (5, 0), endPair: (5, 4)), tokenType: "keyword"),
			Token(range: LSPRange(startPair: (5, 5), endPair: (5, 9)), tokenType: "function"),
			Token(range: LSPRange(startPair: (6, 4), endPair: (6, 7)), tokenType: "namespace"),
			Token(range: LSPRange(startPair: (6, 8), endPair: (6, 15)), tokenType: "function"),
			Token(range: LSPRange(startPair: (6, 16), endPair: (6, 29)), tokenType: "string"),
		]

		XCTAssertEqual(tokens, expectedTokens)
	}
}
