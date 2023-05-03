extension Sequence {
  @inline(__always)
  public func compactMap<E>(_ type: E.Type) -> [E] {
    compactMap { $0 as? E }
  }

  @inline(__always)
  public func rejectNils<Wrapped>()
  -> [Wrapped] where Element == Wrapped? {
    compactMap { $0 }
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
