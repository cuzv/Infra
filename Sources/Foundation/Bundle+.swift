import Foundation

public extension Bundle {
  func inner(named name: String) -> Bundle {
    guard
      let url = url(forResource: name, withExtension: "bundle"),
      let bundle = Bundle(url: url)
    else {
      fatalError("Can't find '\(name)' bundle")
    }
    return bundle
  }
}
