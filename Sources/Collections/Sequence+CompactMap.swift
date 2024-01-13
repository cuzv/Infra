public extension Sequence {
  @inline(__always)
  func compactMap<E>(_ type: E.Type) -> [E] {
    compactMap { $0 as? E }
  }

  @inline(__always)
  func rejectNils<Wrapped>()
    -> [Wrapped] where Element == Wrapped?
  {
    compactMap { $0 }
  }
}

public extension LazySequence {
  @inline(__always)
  func compactMap<E>(
    _ type: E.Type
  ) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Elements, E?>>, E> {
    compactMap { $0 as? E }
  }
}

public extension LazyMapSequence {
  @inline(__always)
  func compactMap<E>(
    _ type: E.Type
  ) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Elements, E?>>, E> {
    compactMap { $0 as? E }
  }
}

public extension LazyFilterSequence {
  @inline(__always)
  func compactMap<E>(
    _ type: E.Type
  ) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Elements, E?>>, E> {
    compactMap { $0 as? E }
  }
}
