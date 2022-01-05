// MARK: - Map

extension Sequence {
  @inline(__always)
  public func map<T>(_ type: T.Type) -> [T?] {
    map { $0 as? T }
  }

  @inline(__always)
  public func map<A, B>(
    _ transformA: @escaping (Element) throws -> A,
    _ transformB: @escaping (Element) throws -> B
  ) rethrows -> [(A, B)] {
    try map { e in
      (try transformA(e), try transformB(e))
    }
  }

  @inline(__always)
  public func map<A, B, C>(
    _ transformA: @escaping (Element) throws -> A,
    _ transformB: @escaping (Element) throws -> B,
    _ transformC: @escaping (Element) throws -> C
  ) rethrows -> [(A, B, C)] {
    try map { e in
      (try transformA(e),
       try transformB(e),
       try transformC(e))
    }
  }

  @inline(__always)
  public func succeeding<Successor>(
    _ output: @autoclosure () -> Successor
  ) -> [Successor] {
    map { _ in output() }
  }
}

extension LazySequence {
  @inline(__always)
  public func map<U>(
    _ type: U.Type
  ) -> LazyMapSequence<Base, U?> {
    map { $0 as? U }
  }

  @inline(__always)
  public func map<A, B>(
    _ transformA: @escaping (Element) throws -> A,
    _ transformB: @escaping (Element) throws -> B
  ) rethrows -> [(A, B)] {
    try map { e in
      (try transformA(e), try transformB(e))
    }
  }

  @inline(__always)
  public func map<A, B>(
    _ transformA: @escaping (Element) -> A,
    _ transformB: @escaping (Element) -> B
  ) -> LazyMapSequence<Elements, (A, B)> {
    map { e in
      (transformA(e), transformB(e))
    }
  }

  @inline(__always)
  public func map<A, B, C>(
    _ transformA: @escaping (Element) throws -> A,
    _ transformB: @escaping (Element) throws -> B,
    _ transformC: @escaping (Element) throws -> C
  ) rethrows -> [(A, B, C)] {
    try map { e in
      (try transformA(e),
       try transformB(e),
       try transformC(e))
    }
  }

  @inline(__always)
  public func map<A, B, C>(
    _ transformA: @escaping (Element) -> A,
    _ transformB: @escaping (Element) -> B,
    _ transformC: @escaping (Element) -> C
  ) -> LazyMapSequence<Elements, (A, B, C)> {
    map { e in
      (transformA(e),
       transformB(e),
       transformC(e))
    }
  }

  @inline(__always)
  public func succeeding<Successor>(
    _ output: @escaping @autoclosure () -> Successor
  ) -> LazyMapSequence<Elements, Successor> {
    map { _ in output() }
  }
}

extension LazyMapSequence {
  @inline(__always)
  public func map<E>(
    _ type: E.Type
  ) -> LazyMapSequence<Base, E?> {
    map { $0 as? E }
  }

  @inline(__always)
  public func map<A, B>(
    _ transformA: @escaping (Element) throws -> A,
    _ transformB: @escaping (Element) throws -> B
  ) rethrows -> [(A, B)] {
    try map { e in
      (try transformA(e), try transformB(e))
    }
  }

  @inline(__always)
  public func map<A, B>(
    _ transformA: @escaping (Element) -> A,
    _ transformB: @escaping (Element) -> B
  ) -> LazyMapSequence<Base, (A, B)> {
    map { e in
      (transformA(e), transformB(e))
    }
  }

  @inline(__always)
  public func map<A, B, C>(
    _ transformA: @escaping (Element) throws -> A,
    _ transformB: @escaping (Element) throws -> B,
    _ transformC: @escaping (Element) throws -> C
  ) rethrows -> [(A, B, C)] {
    try map { e in
      (try transformA(e),
       try transformB(e),
       try transformC(e))
    }
  }

  @inline(__always)
  public func map<A, B, C>(
    _ transformA: @escaping (Element) -> A,
    _ transformB: @escaping (Element) -> B,
    _ transformC: @escaping (Element) -> C
  ) -> LazyMapSequence<Base, (A, B, C)> {
    map { e in
      (transformA(e),
       transformB(e),
       transformC(e))
    }
  }

  @inline(__always)
  public func succeeding<Successor>(
    _ output: @escaping @autoclosure () -> Successor
  ) -> LazyMapSequence<Base, Successor> {
    map { _ in output() }
  }
}

extension LazyFilterSequence {
  @inline(__always)
  public func map<U>(_ type: U.Type) -> LazyMapSequence<Self, U?> {
    map { $0 as? U }
  }

  @inline(__always)
  public func map<A, B>(
    _ transformA: @escaping (Element) throws -> A,
    _ transformB: @escaping (Element) throws -> B
  ) rethrows -> [(A, B)] {
    try map { e in
      (try transformA(e), try transformB(e))
    }
  }

  @inline(__always)
  public func map<A, B>(
    _ transformA: @escaping (Element) -> A,
    _ transformB: @escaping (Element) -> B
  ) -> LazyMapSequence<Elements, (A, B)> {
    map { e in
      (transformA(e), transformB(e))
    }
  }

  @inline(__always)
  public func map<A, B, C>(
    _ transformA: @escaping (Element) throws -> A,
    _ transformB: @escaping (Element) throws -> B,
    _ transformC: @escaping (Element) throws -> C
  ) rethrows -> [(A, B, C)] {
    try map { e in
      (try transformA(e),
       try transformB(e),
       try transformC(e))
    }
  }

  @inline(__always)
  public func map<A, B, C>(
    _ transformA: @escaping (Element) -> A,
    _ transformB: @escaping (Element) -> B,
    _ transformC: @escaping (Element) -> C
  ) -> LazyMapSequence<Elements, (A, B, C)> {
    map { e in
      (transformA(e),
       transformB(e),
       transformC(e))
    }
  }

  @inline(__always)
  public func succeeding<Successor>(
    _ output: @escaping @autoclosure () -> Successor
  ) -> LazyMapSequence<Elements, Successor> {
    map { _ in output() }
  }
}

// MARK: - Mutate

extension Sequence {
  @inline(__always)
  public func mutate(
    _ mutation: @escaping (inout Element) -> Void
  ) -> [Element] {
    map { output in
      var result = output
      mutation(&result)
      return result
    }
  }
}

extension LazySequence {
  @inline(__always)
  public func mutate(
    _ mutation: @escaping (inout Element) -> Void
  ) ->  LazyMapSequence<Elements, Element> {
    map { output in
      var result = output
      mutation(&result)
      return result
    }
  }
}

// MARK: - CompactMap

extension Sequence {
  @inline(__always)
  public func compactMap<E>(_ type: E.Type) -> [E] {
    compactMap { $0 as? E }
  }
}

extension LazySequence {
  @inline(__always)
  public func compactMap<E>(
    _ type: E.Type
  ) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Elements, E?>>, E> {
    compactMap { $0 as? E }
  }
}

extension LazyMapSequence {
  @inline(__always)
  public func compactMap<E>(
    _ type: E.Type
  ) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Elements, E?>>, E> {
    compactMap { $0 as? E }
  }
}

extension LazyFilterSequence {
  @inline(__always)
  public func compactMap<E>(
    _ type: E.Type
  ) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Elements, E?>>, E> {
    compactMap { $0 as? E }
  }
}

// MARK: - Filter

extension Sequence {
  @inline(__always)
  public func filter<T>(on type: T.Type) -> [Element] {
    filter { $0 is T }
  }

  @inline(__always)
  public func filter<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) == value }
  }

  @inline(__always)
  public func filter(
    _ valuesToFilter: Element...
  ) -> [Element] where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  public func filter<S>(
    _ valuesToFilter: S
  ) -> [Element] where S: Sequence, S.Element == Element, Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }
}

extension LazySequence {
  @inline(__always)
  public func filter<T>(on type: T.Type) -> LazyFilterSequence<Base> {
    filter { $0 is T }
  }

  @inline(__always)
  public func filter<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> LazyFilterSequence<Elements> where Value: Equatable {
    filter { transform($0) == value }
  }

  @inline(__always)
  public func filter<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) == value }
  }

  @inline(__always)
  public func filter(
    _ valuesToFilter: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  public func filter<S>(
    _ valuesToFilter: S
  ) -> LazyFilterSequence<Elements>
  where S: Sequence, S.Element == Element, Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }
}

extension LazyMapSequence {
  @inline(__always)
  public func filter<T>(on type: T.Type) -> LazyFilterSequence<Elements> {
    filter { $0 is T }
  }

  @inline(__always)
  public func filter<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> LazyFilterSequence<Elements> where Value: Equatable {
    filter { transform($0) == value }
  }

  @inline(__always)
  public func filter<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) == value }
  }

  @inline(__always)
  public func filter(
    _ valuesToFilter: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  public func filter<S>(
    _ valuesToFilter: S
  ) -> LazyFilterSequence<Elements>
  where S: Sequence, S.Element == Element, Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }
}

extension LazyFilterSequence {
  @inline(__always)
  public func filter<T>(on type: T.Type) -> Self {
    filter { $0 is T }
  }

  @inline(__always)
  public func filter<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> Self where Value: Equatable {
    filter { transform($0) == value }
  }

  @inline(__always)
  public func filter<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) == value }
  }

  @inline(__always)
  public func filter(
    _ valuesToFilter: Element...
  ) -> Self where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  public func filter<S>(
    _ valuesToFilter: S
  ) -> Self where S: Sequence, S.Element == Element, Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }
}

// MARK: - Drop

extension Sequence {
  @inline(__always)
  public func drop<T>(on type: T.Type) -> DropWhileSequence<Self> {
    drop { $0 is T }
  }

  @inline(__always)
  public func drop<Value>(
    on transform: (Element) -> Value, equals value: Value
  ) -> DropWhileSequence<Self> where Value: Equatable {
    drop { transform($0) == value }
  }

  @inline(__always)
  public func drop<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> DropWhileSequence<Self> where Value: Equatable {
    try drop { try transform($0) == value }
  }

  @inline(__always)
  public func drop(
    _ valuesToDrop: Element...
  ) -> DropWhileSequence<Self> where Element: Equatable {
    drop { valuesToDrop.contains($0) }
  }

  @inline(__always)
  public func drop<S>(
    _ valuesToDrop: S
  ) -> DropWhileSequence<Self> where S: Sequence, S.Element == Element, Element: Equatable {
    drop { valuesToDrop.contains($0) }
  }
}

extension LazySequence {
  @inline(__always)
  public func drop<T>(
    _ type: T.Type
  ) -> LazyDropWhileSequence<Elements> {
    drop { $0 is T }
  }

  @inline(__always)
  public func drop<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> LazyDropWhileSequence<Elements> where Value: Equatable {
    drop { transform($0) == value }
  }

  @inline(__always)
  public func drop<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> DropWhileSequence<Self> where Value: Equatable {
    try drop { try transform($0) == value }
  }

  @inline(__always)
  public func drop(
    _ valuesToDrop: Element...
  ) -> LazyDropWhileSequence<Elements> where Element: Equatable {
    drop { valuesToDrop.contains($0) }
  }

  @inline(__always)
  public func drop<S>(
    _ valuesToDrop: S
  ) -> LazyDropWhileSequence<Elements>
  where S: Sequence, S.Element == Element, Element: Equatable {
    drop { valuesToDrop.contains($0) }
  }
}

extension LazyMapSequence {
  @inline(__always)
  public func drop<T>(
    on type: T.Type
  ) -> LazyDropWhileSequence<Elements> {
    drop { $0 is T }
  }

  @inline(__always)
  public func drop<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> LazyDropWhileSequence<Elements> where Value: Equatable {
    drop { transform($0) == value }
  }

  @inline(__always)
  public func drop<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> DropWhileSequence<Self> where Value: Equatable {
    try drop { try transform($0) == value }
  }

  @inline(__always)
  public func drop(
    _ valuesToDrop: Element...
  ) -> LazyDropWhileSequence<Elements> where Element: Equatable {
    drop { valuesToDrop.contains($0) }
  }

  @inline(__always)
  public func drop<S>(_ valuesToDrop: S ) -> LazyDropWhileSequence<Elements>
  where S: Sequence, S.Element == Element, Element: Equatable {
    drop { valuesToDrop.contains($0) }
  }
}

extension LazyFilterSequence {
  @inline(__always)
  public func drop<T>(
    on type: T.Type
  ) -> LazyDropWhileSequence<Elements> {
    drop { $0 is T }
  }

  @inline(__always)
  public func drop<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> LazyDropWhileSequence<Elements> where Value: Equatable {
    drop { transform($0) == value }
  }

  @inline(__always)
  public func drop<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> DropWhileSequence<Self> where Value: Equatable {
    try drop { try transform($0) == value }
  }

  @inline(__always)
  public func drop(
    _ valuesToDrop: Element...
  ) -> LazyDropWhileSequence<Elements> where Element: Equatable {
    drop { valuesToDrop.contains($0) }
  }

  @inline(__always)
  public func drop<S>(_ valuesToDrop: S) -> LazyDropWhileSequence<Elements>
  where S: Sequence, S.Element == Element, Element: Equatable {
    drop { valuesToDrop.contains($0) }
  }
}

// MARK: - Sort

extension Sequence {
  @inlinable
  public func sorted<T>(
    by transform: (Element) throws -> T
  ) rethrows -> [Element] where T: Comparable {
    try sorted { lhs, rhs in
      (try transform(lhs)) < (try transform(rhs))
    }
  }

  @inlinable
  public func sorted<T>(
    by transform: (Element) throws -> T?
  ) rethrows -> [Element] where T: Comparable {
    try sorted { lhs, rhs in
      if let lv = (try transform(lhs)), let rv = (try transform(rhs)) {
        return lv < rv
      } else {
        return true
      }
    }
  }

  @inlinable
  public func sorted<M, S>(
    by majorTransform: (Element) throws -> M,
    or secondaryTransform: (Element) throws -> S
  ) rethrows -> [Element] where M: Comparable, S: Comparable {
    try sorted { lhs, rhs in
      let lm = try majorTransform(lhs)
      let rm = try majorTransform(rhs)
      if lm == rm {
        let ls = try secondaryTransform(lhs)
        let rs = try secondaryTransform(rhs)
        return ls < rs
      } else {
        return lm < rm
      }
    }
  }
}

// MARK: - Unique

extension Sequence {
  /// Returns a new stable array containing the elements of this sequence that do not occur in the given sequence.
  ///
  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  public func subtracting<Other: Sequence, Subject: Hashable>(
    _ other: Other,
    on projection: (Element) throws -> Subject
  ) rethrows -> [Element] where Other.Element == Element {
    var seen = try Set<Subject>(other.map(projection))
    return try filter {
      try seen.insert(projection($0)).inserted
    }
  }

  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  public func removingDuplicates<Subject: Hashable>(
    on projection: (Element) throws -> Subject
  ) rethrows -> [Iterator.Element] {
    try subtracting([], on: projection)
  }
}

extension Sequence where Iterator.Element: Hashable {
  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  public var uniqued: [Iterator.Element] {
    removingDuplicates()
  }

  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  public func removingDuplicates() -> [Iterator.Element] {
    removingDuplicates(on: \.hashValue)
  }

  /// Returns a new stable array containing the elements of this sequence that do not occur in the given sequence.
  ///
  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  public func subtracting<S>(_ other: S) -> [Iterator.Element]
  where S: Sequence, S.Element == Element {
    subtracting(other, on: \.hashValue)
  }
}
