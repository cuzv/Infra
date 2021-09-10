import Foundation

public protocol Differentiable {
  associatedtype Value
  var last: Value { get }
  var current: Value { get }
}

extension Differentiable
where
  Value: RangeReplaceableCollection,
  Value.Element: Hashable
{
  public var mergence: [Value.Element] {
    if current.isEmpty {
      return .init(last)
    } else if last.isEmpty {
      return .init(current)
    } else {
      return (current + last)
        .map(UniqueHashable.init(wrapped:))
        .removingDuplicates()
        .map(\.wrapped)
    }
  }

  public var addition: [Value.Element] {
    if current.isEmpty {
      return []
    } else if last.isEmpty {
      return .init(current)
    } else {
      return current.map(UniqueHashable.init(wrapped:))
        .subtracting(
          last.map(UniqueHashable.init(wrapped:))
        )
        .map(\.wrapped)
    }
  }

  public var deletion: [Value.Element] {
    if current.isEmpty {
      return .init(last)
    } else if last.isEmpty {
      return .init([])
    } else {
      return last.map(UniqueHashable.init(wrapped:))
        .subtracting(
          current.map(UniqueHashable.init(wrapped:))
        )
        .map(\.wrapped)
    }
  }
}
