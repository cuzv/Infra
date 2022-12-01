// MARK: - Sequence

public extension Sequence {
  @inline(__always)
  func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
    map { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func map<T>(_ keyPath: KeyPath<Element, T?>) -> [T?] {
    map { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func flatMap<S>(
    _ keyPath: KeyPath<Element, S>
  ) -> [S.Element] where S: Sequence {
    flatMap { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func compactMap<E>(_ keyPath: KeyPath<Element, E?>) -> [E] {
    compactMap { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func filter(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
    filter { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func filter(_ keyPath: KeyPath<Element, Bool?>) -> [Element] {
    filter { true == $0[keyPath: keyPath] }
  }

  @inline(__always)
  func omit(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
    filter { !$0[keyPath: keyPath] }
  }

  @inline(__always)
  func omit(_ keyPath: KeyPath<Element, Bool?>) -> [Element] {
    filter { false == $0[keyPath: keyPath] }
  }

  @inline(__always)
  func drop(_ keyPath: KeyPath<Element, Bool>) -> DropWhileSequence<Self> {
    drop { $0[keyPath: keyPath] }
  }
}

// MARK: - LazySequence

public extension LazySequence {
  @inline(__always)
  func map<U>(
    _ keyPath: KeyPath<Element, U>
  ) -> LazyMapSequence<Base, U> {
    map { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func map<T>(
    _ keyPath: KeyPath<Element, T?>
  ) -> LazyMapSequence<Elements, T?> {
    map { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func flatMap<S>(
    _ keyPath: KeyPath<Element, S>
  ) -> LazySequence<FlattenSequence<LazyMapSequence<Elements, S>>> where S: Sequence {
    flatMap { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func compactMap<E>(
    _ keyPath: KeyPath<Element, E?>
  ) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Elements, E?>>, E> {
    compactMap { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func filter(_ keyPath: KeyPath<Element, Bool>) -> LazyFilterSequence<Base> {
    filter { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func filter(_ keyPath: KeyPath<Element, Bool?>) -> LazyFilterSequence<Elements> {
    filter { true == $0[keyPath: keyPath] }
  }

  @inline(__always)
  func omit(_ keyPath: KeyPath<Element, Bool>) -> LazyFilterSequence<Base> {
    filter { !$0[keyPath: keyPath] }
  }

  @inline(__always)
  func omit(_ keyPath: KeyPath<Element, Bool?>) -> LazyFilterSequence<Elements> {
    filter { false == $0[keyPath: keyPath] }
  }

  @inline(__always)
  func drop(
    _ keyPath: KeyPath<Element, Bool>
  ) -> LazyDropWhileSequence<LazySequence<Base>.Elements> {
    drop { $0[keyPath: keyPath] }
  }
}

// MARK: - LazyMapSequence

public extension LazyMapSequence {
  @inline(__always)
  func map<E>(
    _ keyPath: KeyPath<Element, E>
  ) -> LazyMapSequence<Base, E> {
    map { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func map<E>(
    _ keyPath: KeyPath<Element, E?>
  ) -> LazyMapSequence<Base, E?> {
    map { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func flatMap<E>(
    _ keyPath: KeyPath<Element, E>
  ) -> LazySequence<FlattenSequence<LazyMapSequence<Elements, E>>> where E: Sequence {
    flatMap { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func compactMap<E>(
    _ keyPath: KeyPath<Element, E?>
  ) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Elements, E?>>, E> {
    compactMap { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func filter(_ keyPath: KeyPath<Element, Bool>) -> LazyFilterSequence<Elements> {
    filter { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func filter(_ keyPath: KeyPath<Element, Bool?>) -> LazyFilterSequence<Elements> {
    filter { true == $0[keyPath: keyPath] }
  }

  @inline(__always)
  func omit(_ keyPath: KeyPath<Element, Bool>) -> LazyFilterSequence<Elements> {
    filter { !$0[keyPath: keyPath] }
  }

  @inline(__always)
  func omit(_ keyPath: KeyPath<Element, Bool?>) -> LazyFilterSequence<Elements> {
    filter { false == $0[keyPath: keyPath] }
  }

  @inline(__always)
  func drop(
    _ keyPath: KeyPath<Element, Bool>
  ) -> LazyDropWhileSequence<LazyMapSequence<Base, Element>.Elements> {
    drop { $0[keyPath: keyPath] }
  }
}

// MARK: - LazyFilterSequence

public extension LazyFilterSequence {
  @inline(__always)
  func map<U>(_ keyPath: KeyPath<Element, U>) -> LazyMapSequence<Self, U> {
    map { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func map<E>(
    _ keyPath: KeyPath<Element, E?>
  ) -> LazyMapSequence<Elements, E?> {
    map { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func flatMap<E>(
    _ keyPath: KeyPath<Element, E>
  ) -> LazySequence<FlattenSequence<LazyMapSequence<Elements, E>>>where E: Sequence {
    flatMap { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func compactMap<E>(
    _ keyPath: KeyPath<Element, E?>
  ) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Elements, E?>>, E> {
    compactMap { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func filter(_ keyPath: KeyPath<Element, Bool>) -> Self {
    filter { $0[keyPath: keyPath] }
  }

  @inline(__always)
  func filter(_ keyPath: KeyPath<Element, Bool?>) -> Self {
    filter { true == $0[keyPath: keyPath] }
  }

  @inline(__always)
  func omit(_ keyPath: KeyPath<Element, Bool>) -> Self {
    filter { !$0[keyPath: keyPath] }
  }

  @inline(__always)
  func omit(_ keyPath: KeyPath<Element, Bool?>) -> Self {
    filter { false == $0[keyPath: keyPath] }
  }

  @inline(__always)
  func drop(
    _ keyPath: KeyPath<Element, Bool>
  ) -> LazyDropWhileSequence<LazyFilterSequence<Base>.Elements> {
    drop { $0[keyPath: keyPath] }
  }
}
