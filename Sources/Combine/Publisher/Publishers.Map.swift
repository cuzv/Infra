#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Publisher {
  public func eraseType() -> Publishers.Map<Self, Void> {
    map { _ in () }
  }

  public func with<Inserted>(
    _ inserted: Inserted
  ) -> Publishers.Map<Self, (Output, Inserted)> {
    map { ($0, inserted) }
  }

  public func withDeferred<Inserted>(
    _ inserted: @escaping @autoclosure () -> Inserted
  ) -> Publishers.Map<Self, (Output, Inserted)> {
    map { ($0, inserted()) }
  }

  public func succeeding<Successor>(
    _ successor: Successor
  ) -> Publishers.Map<Self, Successor> {
    map { _ in successor }
  }

  public func succeedingDeferred<Successor>(
    _ successor: @escaping @autoclosure () -> Successor
  ) -> Publishers.Map<Self, Successor> {
    map { _ in successor() }
  }

  public func reverse<A, B>() -> Publishers.Map<Self, (B, A)>
  where Output == (A, B) {
    map { ($0.1, $0.0) }
  }

  public func reverse<A, B, C>() -> Publishers.Map<Self, (C, B, A)>
  where Output == (A, B, C) {
    map { ($0.2, $0.1, $0.0) }
  }

  public func squeeze<A, B, C>() -> Publishers.Map<Self, (A, B, C)>
  where Output == ((A, B), C) {
    map { ($0.0, $0.1, $1) }
  }

  public func squeeze<A, B, C>() -> Publishers.Map<Self, (A, B, C)>
  where Output == (A, (B, C)) {
    map { ($0, $1.0, $1.1) }
  }

  public func `as`<Transformed>(
    _ transformedType: Transformed.Type
  ) -> Publishers.Map<Self, Transformed?> {
    map { $0 as? Transformed }
  }

  public func map<A, B>(
    _ transformA: @escaping (Output) -> A,
    _ transformB: @escaping (Output) -> B
  ) -> Publishers.Map<Self, (A, B)> {
    map { output in
      (transformA(output), transformB(output))
    }
  }

  public func map<A, B, C>(
    _ transformA: @escaping (Output) -> A,
    _ transformB: @escaping (Output) -> B,
    _ transformC: @escaping (Output) -> C
  ) -> Publishers.Map<Self, (A, B, C)> {
    map { output in
      (transformA(output), transformB(output), transformC(output))
    }
  }

  public func mutate(
    _ mutation: @escaping (inout Output) -> Void
  ) -> Publishers.Map<Self, Output> {
    map { output in
      var result = output
      mutation(&result)
      return result
    }
  }

  public func result<T>(
    _ transform: @escaping (Output) throws -> T
  ) -> Publishers.Map<Self, Result<T, AnyError>> {
    map { output in
      Result(attempt: {
        try transform(output)
      })
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Publisher where Output: Sequence {
  public func sorted(
    by areInIncreasingOrder: @escaping (Output.Element, Output.Element) -> Bool
  ) -> Publishers.Map<Self, [Output.Element]> {
    map {
      $0.lazy.sorted(by: areInIncreasingOrder)
    }
  }

  public func sorted<T>(
    by transform: @escaping (Output.Element) throws -> T
  ) rethrows -> Publishers.TryMap<Self, [Output.Element]> where T: Comparable {
    tryMap {
      try $0.lazy.sorted { lhs, rhs in
        (try transform(lhs)) < (try transform(rhs))
      }
    }
  }

  public func sorted<T>(
    by transform: @escaping (Output.Element) -> T
  ) -> Publishers.Map<Self, [Output.Element]> where T: Comparable {
    map {
      $0.lazy.sorted { lhs, rhs in
        transform(lhs) < transform(rhs)
      }
    }
  }

  public func reversed() -> Publishers.Map<Self, [Output.Element]> {
    map {
      $0.lazy.reversed()
    }
  }
}
#endif
