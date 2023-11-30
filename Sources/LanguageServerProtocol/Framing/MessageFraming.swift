import Foundation
import JSONRPC

enum MessageFramingError: Error {
	case malformedData
	case missingField
	case contentLengthMissing
}

struct MessageFraming {
	public static func frame(_ data: Data) -> Data {
		let length = data.count

		let header = "Content-Length: \(length)\r\n\r\n"
		let headerData = Data(header.utf8)

		return headerData + data
	}

	public static func readHeader(_ value: String) throws -> (String, String) {
		let components = value.components(separatedBy: ":")
		let name = components[0].trimmingCharacters(in: .whitespaces)
		let value = components[1].trimmingCharacters(in: .whitespaces)

		return (name, value)
	}
}
