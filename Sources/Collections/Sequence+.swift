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
  public func filter<T>(_ type: T.Type) -> [Element] {
    filter { $0 is T }
  }

  @inline(__always)
  public func filter(_ keyPath: KeyPath<Element, Bool?>) -> [Element] {
    filter { true == $0[keyPath: keyPath] }
  }

  @inline(__always)
  public func filter(
    _ valuesToFilter: Element...
  ) -> [Element] where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  public func filter<S: Sequence>(
    _ valuesToFilter: S
  ) -> [Element] where S.Element == Element, Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }
}

extension LazySequence {
  @inline(__always)
  public func filter<T>(_ type: T.Type) -> LazyFilterSequence<Base> {
    filter { $0 is T }
  }

  @inline(__always)
  public func filter(
    _ keyPath: KeyPath<Element, Bool?>
  ) -> LazyFilterSequence<Elements> {
    filter { true == $0[keyPath: keyPath] }
  }

  @inline(__always)
  public func filter(
    _ valuesToFilter: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  public func filter<S: Sequence>(
    _ valuesToFilter: S
  ) -> LazyFilterSequence<Elements>
  where S.Element == Element, Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }
}

extension LazyMapSequence {
  @inline(__always)
  public func filter<T>(_ type: T.Type) -> LazyFilterSequence<Elements> {
    filter { $0 is T }
  }

  @inline(__always)
  public func filter(
    _ keyPath: KeyPath<Element, Bool?>
  ) -> LazyFilterSequence<Elements> {
    filter { true == $0[keyPath: keyPath] }
  }

  @inline(__always)
  public func filter(
    _ valuesToFilter: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  public func filter<S: Sequence>(
    _ valuesToFilter: S
  ) -> LazyFilterSequence<Elements>
  where S.Element == Element, Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }
}

extension LazyFilterSequence {
  @inline(__always)
  public func filter<T>(_ type: T.Type) -> Self {
    filter { $0 is T }
  }

  @inline(__always)
  public func filter(_ keyPath: KeyPath<Element, Bool?>) -> Self {
    filter { true == $0[keyPath: keyPath] }
  }

  @inline(__always)
  public func filter(
    _ valuesToFilter: Element...
  ) -> Self where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  public func filter<S: Sequence>(
    _ valuesToFilter: S
  ) -> Self where S.Element == Element, Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }
}

// MARK: - Ignore

extension Sequence {
  @inline(__always)
  public func ignore<T>(_ type: T.Type) -> [Element] {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func ignore(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
    filter { !$0[keyPath: keyPath] }
  }

  @inline(__always)
  public func ignore(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func ignore(
    _ valuesToIgnore: Element...
  ) -> [Element] where Element: Equatable {
    filter { !valuesToIgnore.contains($0) }
  }

  @inline(__always)
  public func ignore<S: Sequence>(
    _ valuesToIgnore: S
  ) -> [Element] where S.Element == Element, Element: Equatable {
    filter { !valuesToIgnore.contains($0) }
  }
}

extension LazySequence {
  @inline(__always)
  public func ignore<T>(
    _ type: T.Type
  ) -> LazyFilterSequence<Elements> {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func ignore(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func ignore(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> LazyFilterSequence<Elements> {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  public func ignore(
    _ valuesToIgnore: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { !valuesToIgnore.contains($0) }
  }

  @inline(__always)
  public func ignore<S: Sequence>(
    _ valuesToIgnore: S
  ) -> LazyFilterSequence<Elements>
  where S.Element == Element, Element: Equatable {
    filter { !valuesToIgnore.contains($0) }
  }
}

extension LazyMapSequence {
  @inline(__always)
  public func ignore<T>(
    _ type: T.Type
  ) -> LazyFilterSequence<Elements> {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func ignore(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func ignore(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> LazyFilterSequence<Elements> {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  public func ignore(
    _ valuesToIgnore: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { !valuesToIgnore.contains($0) }
  }

  @inline(__always)
  public func ignore<S: Sequence>(
    _ valuesToIgnore: S
  ) -> LazyFilterSequence<Elements>
  where S.Element == Element, Element: Equatable {
    filter { !valuesToIgnore.contains($0) }
  }
}

extension LazyFilterSequence {
  @inline(__always)
  public func ignore<T>(
    _ type: T.Type
  ) -> Self {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func ignore(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func ignore(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> Self {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  public func ignore(
    _ valuesToIgnore: Element...
  ) -> Self where Element: Equatable {
    filter { !valuesToIgnore.contains($0) }
  }

  @inline(__always)
  public func ignore<S: Sequence>(
    _ valuesToIgnore: S
  ) -> Self
  where S.Element == Element, Element: Equatable {
    filter { !valuesToIgnore.contains($0) }
  }
}

// MARK: - Sort

extension Sequence {
  @inlinable
  public func sorted<T: Comparable>(
    by keyPath: KeyPath<Element, T>
  ) -> [Element] {
    sorted { lhs, rhs in
      lhs[keyPath: keyPath] < rhs[keyPath: keyPath]
    }
  }

  @inlinable
  public func sorted<T: Comparable>(
    by keyPath: KeyPath<Element, T?>
  ) -> [Element] {
    sorted { lhs, rhs in
      if let lv = lhs[keyPath: keyPath], let rv = rhs[keyPath: keyPath] {
        return lv < rv
      } else {
        return true
      }
    }
  }

  @inlinable
  public func sorted<M: Comparable, S: Comparable>(
    by majorKeyPath: KeyPath<Element, M>,
    backup secondaryKeyPath: KeyPath<Element, S>
  ) -> [Element] {
    sorted { lhs, rhs in
      let lm = lhs[keyPath: majorKeyPath]
      let rm = rhs[keyPath: majorKeyPath]
      if lm == rm {
        let ls = lhs[keyPath: secondaryKeyPath]
        let rs = rhs[keyPath: secondaryKeyPath]
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
  public func subtracting<S: Sequence>(_ other: S) -> [Iterator.Element]
  where S.Element == Element {
    subtracting(other, on: \.hashValue)
  }
}
