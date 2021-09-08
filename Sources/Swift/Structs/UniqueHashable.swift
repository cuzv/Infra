import Foundation

public struct UniqueHashable<Wrapped: Hashable> {
  public let wrapped: Wrapped

  public init(wrapped: Wrapped) {
    self.wrapped = wrapped
  }
}

extension UniqueHashable: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(wrapped.hashValue)
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
}

extension Sequence where Iterator.Element: Hashable {
  /// Complexity: o(N)
  public var hashableUniqued: [Iterator.Element] {
    map(UniqueHashable.init(wrapped:))
      .removingDuplicates()
      .map(\.wrapped)
  }
}
