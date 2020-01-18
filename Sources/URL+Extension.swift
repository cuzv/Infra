import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)")!
    }
}

extension URL {
    public static let documentDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])

    public static let cachesDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0])

    public func resourceValue<T>(forKey key: URLResourceKey) -> T? {
        do {
            let meta = try resourceValues(forKeys: Set([key]))
            return meta.allValues[key] as? T
        } catch {
            return nil
        }
    }

    public func queryParameters() -> [String: String] {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems
        else {
            return [:]
        }

        let pairs = queryItems.map({ ($0.name, $0.value) }).compactMap({ $0 as? (String, String) })
        let result = Dictionary(pairs, uniquingKeysWith: { $1 })
        return result
    }

    public func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return self }
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url ?? self
    }

    public mutating func appendQueryParameters(_ parameters: [String: String]) {
        self = appendingQueryParameters(parameters)
    }

    public func queryValue(for key: String) -> String? {
        URLComponents(string: absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

    public func identicalTo(_ other: URL) -> Bool {
        autoreleasepool { resolvingSymlinksInPath() == other.resolvingSymlinksInPath() }
    }

    public func contains(_ other: URL) -> Bool {
        autoreleasepool {
            resolvingSymlinksInPath()
                .absoluteString
                .lowercased()
                .contains(
                    other.resolvingSymlinksInPath()
                        .absoluteString
                        .lowercased()
                )
        }
    }
}
