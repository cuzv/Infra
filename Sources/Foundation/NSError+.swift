import Foundation

public extension NSError {
  static let unknown = NSError.from("Unknown error")
  static func from(_ desc: String) -> NSError {
    NSError(domain: "ShitHappend", code: -1, userInfo: [NSLocalizedDescriptionKey: desc])
  }
}
