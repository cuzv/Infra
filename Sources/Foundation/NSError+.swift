import Foundation

public extension NSError {
  static let unknown = NSError.from(desc: "Unknown error")

  static func from(domain: String = "com.redrainlab.default", code: Int = -1, desc: String) -> NSError {
    NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: desc])
  }
}
