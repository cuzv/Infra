/// https://nshipster.com/propertywrapper/#changing-synthesized-equality-and-comparison-semantics
@propertyWrapper
public struct CaseInsensitive<Value: StringProtocol> {
  public var wrappedValue: Value

  public init(wrappedValue: Value) {
    self.wrappedValue = wrappedValue
  }
}

import Foundation

extension CaseInsensitive: Comparable {
  private func compare(_ other: CaseInsensitive) -> ComparisonResult {
    wrappedValue.caseInsensitiveCompare(other.wrappedValue)
  }

  @inline(__always)
  public static func == (lhs: CaseInsensitive, rhs: CaseInsensitive) -> Bool {
    lhs.compare(rhs) == .orderedSame
  }

  @inline(__always)
  public static func < (lhs: CaseInsensitive, rhs: CaseInsensitive) -> Bool {
    lhs.compare(rhs) == .orderedAscending
  }

  @inline(__always)
  public static func > (lhs: CaseInsensitive, rhs: CaseInsensitive) -> Bool {
    lhs.compare(rhs) == .orderedDescending
  }
}
