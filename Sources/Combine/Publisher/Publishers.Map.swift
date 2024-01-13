#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publisher {
  func eraseType() -> Publishers.Map<Self, Void> {
    map { _ in () }
  }

  func with<Inserted>(
    _ inserted: Inserted
  ) -> Publishers.Map<Self, (Output, Inserted)> {
    map { ($0, inserted) }
  }

  func withDeferred<Inserted>(
    _ inserted: @escaping @autoclosure () -> Inserted
  ) -> Publishers.Map<Self, (Output, Inserted)> {
    map { ($0, inserted()) }
  }

  func succeeding<Successor>(
    _ successor: Successor
  ) -> Publishers.Map<Self, Successor> {
    map { _ in successor }
  }

  func succeedingDeferred<Successor>(
    _ successor: @escaping @autoclosure () -> Successor
  ) -> Publishers.Map<Self, Successor> {
    map { _ in successor() }
  }

  func reverse<A, B>() -> Publishers.Map<Self, (B, A)>
    where Output == (A, B)
  {
    map { ($0.1, $0.0) }
  }

  func reverse<A, B, C>() -> Publishers.Map<Self, (C, B, A)>
    where Output == (A, B, C)
  {
    map { ($0.2, $0.1, $0.0) }
  }

  func squeeze<A, B, C>() -> Publishers.Map<Self, (A, B, C)>
    where Output == ((A, B), C)
  {
    map { ($0.0, $0.1, $1) }
  }

  func squeeze<A, B, C>() -> Publishers.Map<Self, (A, B, C)>
    where Output == (A, (B, C))
  {
    map { ($0, $1.0, $1.1) }
  }

  func `as`<Transformed>(
    _ transformedType: Transformed.Type
  ) -> Publishers.Map<Self, Transformed?> {
    map { $0 as? Transformed }
  }

  func map<A, B>(
    _ transformA: @escaping (Output) -> A,
    _ transformB: @escaping (Output) -> B
  ) -> Publishers.Map<Self, (A, B)> {
    map { output in
      (transformA(output), transformB(output))
    }
  }

  func map<A, B, C>(
    _ transformA: @escaping (Output) -> A,
    _ transformB: @escaping (Output) -> B,
    _ transformC: @escaping (Output) -> C
  ) -> Publishers.Map<Self, (A, B, C)> {
    map { output in
      (transformA(output), transformB(output), transformC(output))
    }
  }

  func mutate(
    _ mutation: @escaping (inout Output) -> Void
  ) -> Publishers.Map<Self, Output> {
    map { output in
      var result = output
      mutation(&result)
      return result
    }
  }

  func result<T>(
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
public extension Publisher where Output: Sequence {
  func sorted(
    by areInIncreasingOrder: @escaping (Output.Element, Output.Element) -> Bool
  ) -> Publishers.Map<Self, [Output.Element]> {
    map {
      $0.lazy.sorted(by: areInIncreasingOrder)
    }
  }

  func sorted(
    by transform: @escaping (Output.Element) throws -> some Comparable
  ) rethrows -> Publishers.TryMap<Self, [Output.Element]> {
    tryMap {
      try $0.lazy.sorted { lhs, rhs in
        try (transform(lhs)) < transform(rhs)
      }
    }
  }

  func sorted(
    by transform: @escaping (Output.Element) -> some Comparable
  ) -> Publishers.Map<Self, [Output.Element]> {
    map {
      $0.lazy.sorted { lhs, rhs in
        transform(lhs) < transform(rhs)
      }
    }
  }

  func reversed() -> Publishers.Map<Self, [Output.Element]> {
    map {
      $0.lazy.reversed()
    }
  }
}
#endif
