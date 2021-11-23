import Foundation

extension NSRegularExpression {
    func matches(inFullString string: String, options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
        let range = NSMakeRange(0, string.utf16.count)

        return matches(in: string, options: options, range: range)
    }
}

extension NSTextCheckingResult {
    func range(at index: Int, in string: String) -> Range<String.Index>? {
        let nsRange = range(at: index)

        return Range(nsRange, in: string)
    }

    func stringValue(at index: Int, in string: String) -> Substring? {
        guard let captureRange = range(at: index, in: string) else {
            return nil
        }

        return string[captureRange]
    }

    func intValue(at index: Int, in string: String) -> Int? {
        return stringValue(at: index, in: string).flatMap { Int($0) }
    }
}
