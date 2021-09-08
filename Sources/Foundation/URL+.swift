import Foundation

extension URL: ExpressibleByStringLiteral {
  public init(stringLiteral value: StaticString) {
    self = URL(string: "\(value)")!
  }
}

extension URL {
  public static let documentDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
  public static let cachesDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0])
  public static let inboxDirectory = documentDirectory.appendingPathComponent("Inbox")

  public func resourceValue<T>(forKey key: URLResourceKey) -> T? {
    do {
      let meta = try resourceValues(forKeys: Set([key]))
      return meta.allValues[key] as? T
    } catch {
      return nil
    }
  }

  public var queryItems: [URLQueryItem] {
    get { URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems ?? [] }
    mutating set {
      if var components = URLComponents(url: self, resolvingAgainstBaseURL: true) {
        components.queryItems = newValue.isEmpty ? nil : newValue
        if let url = components.url {
          self = url
        }
      }
    }
  }

  public func appendingQueryItems(_ items: [URLQueryItem]) -> URL {
    if var components = URLComponents(url: self, resolvingAgainstBaseURL: true) {
      var queryItems = components.queryItems ?? []
      queryItems.append(contentsOf: items)
      components.queryItems = queryItems
      return components.url ?? self
    } else {
      return self
    }
  }

  public mutating func appendQueryItems(_ items: [URLQueryItem]) {
    self = appendingQueryItems(items)
  }

  public func deletingQueryItems() -> URL {
    if var components = URLComponents(url: self, resolvingAgainstBaseURL: true) {
      components.queryItems = nil
      return components.url ?? self
    } else {
      return self
    }
  }

  public mutating func deleteQueryItems() {
    self = deletingQueryItems()
  }

  public func queryValue(for key: String) -> [String] {
    URLComponents(url: self, resolvingAgainstBaseURL: true)?
      .queryItems?
      .filter {
        $0.name == key
      }
      .compactMap(\.value)
      ??
      []
  }

  public func identicalTo(_ other: URL) -> Bool {
    resolvingSymlinksInPath() == other.resolvingSymlinksInPath()
  }

  public func contains(_ other: URL) -> Bool {
    resolvingSymlinksInPath()
      .absoluteString
      .range(
        of: other.resolvingSymlinksInPath().absoluteString,
        options: [.caseInsensitive]
      ) != nil
  }
}
