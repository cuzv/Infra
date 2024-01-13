import Foundation

public protocol Differentiable {
  associatedtype Value
  var last: Value { get }
  var current: Value { get }
}

public extension Differentiable
  where
  Value: RangeReplaceableCollection,
  Value.Element: Hashable
{
  var mergence: [Value.Element] {
    if current.isEmpty {
      .init(last)
    } else if last.isEmpty {
      .init(current)
    } else {
      (current + last)
        .map(UniqueHashable.init(wrapped:))
        .removingDuplicates()
        .map(\.wrapped)
    }
  }

  var addition: [Value.Element] {
    if current.isEmpty {
      []
    } else if last.isEmpty {
      .init(current)
    } else {
      current.map(UniqueHashable.init(wrapped:))
        .subtracting(
          last.map(UniqueHashable.init(wrapped:))
        )
        .map(\.wrapped)
    }
  }

  var deletion: [Value.Element] {
    if current.isEmpty {
      .init(last)
    } else if last.isEmpty {
      .init([])
    } else {
      last.map(UniqueHashable.init(wrapped:))
        .subtracting(
          current.map(UniqueHashable.init(wrapped:))
        )
        .map(\.wrapped)
    }
  }
}
