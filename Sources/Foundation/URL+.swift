import Foundation

extension URL: ExpressibleByStringLiteral {
  public init(stringLiteral value: StaticString) {
    self = URL(string: "\(value)")!
  }
}

public extension URL {
  static let documentDir = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
  static let cachesDir = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0])
  static let inboxDir = documentDir.appendingPathComponent("Inbox")

  func resourceValue<T>(forKey key: URLResourceKey) -> T? {
    do {
      let meta = try resourceValues(forKeys: Set([key]))
      return meta.allValues[key] as? T
    } catch {
      return nil
    }
  }

  var queryItems: [URLQueryItem] {
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

  func appendingQueryItems(_ items: [URLQueryItem]) -> URL {
    if var components = URLComponents(url: self, resolvingAgainstBaseURL: true) {
      var queryItems = components.queryItems ?? []
      queryItems.append(contentsOf: items)
      components.queryItems = queryItems
      return components.url ?? self
    } else {
      return self
    }
  }

  mutating func appendQueryItems(_ items: [URLQueryItem]) {
    self = appendingQueryItems(items)
  }

  func deletingQueryItems() -> URL {
    if var components = URLComponents(url: self, resolvingAgainstBaseURL: true) {
      components.queryItems = nil
      return components.url ?? self
    } else {
      return self
    }
  }

  mutating func deleteQueryItems() {
    self = deletingQueryItems()
  }

  func queryValue(for key: String) -> [String] {
    URLComponents(url: self, resolvingAgainstBaseURL: true)?
      .queryItems?
      .filter {
        $0.name == key
      }
      .compactMap(\.value)
      ??
      []
  }

  func identicalTo(_ other: URL) -> Bool {
    resolvingSymlinksInPath() == other.resolvingSymlinksInPath()
  }

  func contains(_ other: URL) -> Bool {
    resolvingSymlinksInPath()
      .absoluteString
      .range(
        of: other.resolvingSymlinksInPath().absoluteString,
        options: [.caseInsensitive]
      ) != nil
  }
}

public extension URL {
  init?(itmsAppId: String, writeReview: Bool = false) {
    var link = "itms-apps://itunes.apple.com/app/id\(itmsAppId)?mt=8"
    if writeReview {
      link.append("&action=write-review")
    }
    self.init(string: link)
  }
}
