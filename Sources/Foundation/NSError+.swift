import Foundation

extension NSError {
  public static let unknown = NSError.from("Unknown error")
  public static func from(_ desc: String) -> NSError {
    NSError(domain: "ShitHappend", code: -1, userInfo: [NSLocalizedDescriptionKey: desc])
  }
}
