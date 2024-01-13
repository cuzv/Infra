import Foundation

public extension URLRequest {
  init(url: URL, offset: Int, length: Int) {
    self.init(url: url)
    addValue("bytes=\(offset)-\(offset + length - 1)", forHTTPHeaderField: "Range")
  }
}
