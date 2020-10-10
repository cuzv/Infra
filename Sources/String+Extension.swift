import Foundation

extension String {
    public func trimmingWhitespaces() -> String {
        trimmingCharacters(in: .whitespaces)
    }

    public func trimmingWhitespacesAndNewlines() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public func trimmingCharacters(in str: String) -> String {
        trimmingCharacters(in: CharacterSet(charactersIn: str))
    }

    public func urlDecoding() -> String {
        removingPercentEncoding ?? self
    }

    public mutating func urlDecode() {
        self = urlDecoding()
    }

    public func urlEncoding() -> String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }

    public mutating func urlEncode() {
        self = urlEncoding()
    }

    public func encodingPercent(withAllowedCharacters allowedCharacters: CharacterSet) -> String {
        addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? self
    }

    public var characters: [Character] {
        Array(self)
    }

    public func char(at location: Int) -> Character? {
        guard location >= 0 && location < count else { return nil }
        return self[index(startIndex, offsetBy: location)]
    }

    public func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return nil != range(of: string, options: .caseInsensitive)
        }
        return nil != range(of: string)
    }

    public func substring(in range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex ..< upperIndex])
    }

    public subscript(safe range: CountableRange<Int>) -> String? {
        substring(in: range)
    }

    public func substring(in range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex ... upperIndex])
    }

    public subscript(safe range: ClosedRange<Int>) -> String? {
        substring(in: range)
    }

    public func substring(from start: Int, length: Int) -> String? {
        guard length >= 0, start >= 0, start < count  else { return nil }
        let end = start + length
        if end <= count {
            return substring(in: start ..< end)
        } else {
            return substring(in: start ..< count)
        }
    }

    public func substring(from start: Int) -> String? {
        substring(in: start ..< count)
    }

    public func substring(to end: Int) -> String? {
        substring(in: 0 ..< end)
    }

    public func position(of str: String) -> CountableRange<Int>? {
        if let range = range(of: str) {
            return range.lowerBound.utf16Offset(in: self) ..< range.upperBound.utf16Offset(in: self)
        }
        return nil
    }

    public func replacingCharacters(in range: CountableRange<Int>, with: String) -> String {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return self }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return self }
        return replacingCharacters(in: lowerIndex ..< upperIndex, with: with)
    }

    public func replacingCharacters(in range: ClosedRange<Int>, with: String) -> String {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return self }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return self }
        return replacingCharacters(in: lowerIndex ..< upperIndex, with: with)
    }

    public func matches(pattern: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", pattern)
        return emailTest.evaluate(with: self)
    }

    public func isEmail() -> Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        // http://emailregex.com/
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return matches(pattern: regex)
    }

    public func base64Decoded() -> String {
        if let decodedData = Data(base64Encoded: self), let result = String(data: decodedData, encoding: .utf8) {
            return result
        }
        return self
    }

    public func base64Encoded() -> String {
        if let plainData = data(using: .utf8) {
            return plainData.base64EncodedString()
        }
        return self
    }

    public func hasLetters() -> Bool {
        nil != rangeOfCharacter(from: .letters, options: .numeric, range: nil)
    }

    public func hasNumbers() -> Bool {
        nil != rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil)
    }

    public func isAlphabetic() -> Bool {
        hasLetters() && !hasNumbers()
    }

    public func isAlphaNumeric() -> Bool {
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters() && hasNumbers()
    }

    public func isNumeric() -> Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }

    public func isDigits() -> Bool {
        CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }

    public func isPalindrome() -> Bool {
        let letters = filter { $0.isLetter }
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex..<midIndex]
        let secondHalf = letters[midIndex..<letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains(where: { $0.lowercased() != $1.lowercased() })
    }
}

extension String {
    public var nsString: NSString {
        NSString(string: self)
    }

    public var lastPathComponent: String {
        (self as NSString).lastPathComponent
    }

    public var pathExtension: String {
        (self as NSString).pathExtension
    }

    public var deletingLastPathComponent: String {
        (self as NSString).deletingLastPathComponent
    }

    public var deletingPathExtension: String {
        (self as NSString).deletingPathExtension
    }

    public var pathComponents: [String] {
        (self as NSString).pathComponents
    }

    public func appendingPathComponent(_ str: String) -> String {
        (self as NSString).appendingPathComponent(str)
    }

    public func appendingPathExtension(_ str: String) -> String {
        (self as NSString).appendingPathExtension(str) ?? self
    }
}

extension String {
    // a: 97, z: 122
    // A: 65, Z: 90

    public func encodeLetters() -> String {
        var result = [String.Element]()

        for ch in self {
            if ch.isLetter {
                var candidate = ch.asciiValue! + 8

                if ch.isLowercase {
                    if candidate > 122 {
                        candidate = candidate - 122 + 97
                    }
                } else if ch.isUppercase {
                    if candidate > 90 {
                        candidate = candidate - 90 + 65
                    }
                }

                assert(97...122 ~= candidate || 65...90 ~= candidate)

                result.append(.init(.init(candidate)))
            } else {
                result.append(ch)
            }
        }

        return String(result)
    }

    public func decodeLetters() -> String {
        var result = [String.Element]()

        for ch in self {
            if ch.isLetter {
                var candidate = ch.asciiValue! - 8

                if ch.isLowercase {
                    if candidate < 97 {
                        candidate = candidate + 122 - 97
                    }
                } else if ch.isUppercase {
                    if candidate < 90 {
                        candidate = candidate + 90 - 65
                    }
                }

                assert(97...122 ~= candidate || 65...90 ~= candidate)

                result.append(.init(.init(candidate)))
            } else {
                result.append(ch)
            }
        }

        return String(result)
    }
}
