extension Sequence {
  @inline(__always)
  public func omit<T>(_ type: T.Type) -> [Element] {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func omit(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func omit(
    _ valuesToOmit: Element...
  ) -> [Element] where Element: Equatable {
    filter { !valuesToOmit.contains($0) }
  }

  @inline(__always)
  public func omit<S: Sequence>(
    _ valuesToOmit: S
  ) -> [Element] where S.Element == Element, Element: Equatable {
    filter { !valuesToOmit.contains($0) }
  }
}

extension LazySequence {
  @inline(__always)
  public func omit<T>(
    _ type: T.Type
  ) -> LazyFilterSequence<Elements> {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func omit(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func omit(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> LazyFilterSequence<Elements> {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  public func omit(
    _ valuesToOmit: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { !valuesToOmit.contains($0) }
  }

  @inline(__always)
  public func omit<S: Sequence>(
    _ valuesToOmit: S
  ) -> LazyFilterSequence<Elements>
  where S.Element == Element, Element: Equatable {
    filter { !valuesToOmit.contains($0) }
  }
}

extension LazyMapSequence {
  @inline(__always)
  public func omit<T>(
    _ type: T.Type
  ) -> LazyFilterSequence<Elements> {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func omit(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func omit(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> LazyFilterSequence<Elements> {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  public func omit(
    _ valuesToOmit: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { !valuesToOmit.contains($0) }
  }

  @inline(__always)
  public func omit<S: Sequence>(
    _ valuesToOmit: S
  ) -> LazyFilterSequence<Elements>
  where S.Element == Element, Element: Equatable {
    filter { !valuesToOmit.contains($0) }
  }
}

extension LazyFilterSequence {
  @inline(__always)
  public func omit<T>(
    _ type: T.Type
  ) -> Self {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func omit(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func omit(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> Self {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  public func omit(
    _ valuesToOmit: Element...
  ) -> Self where Element: Equatable {
    filter { !valuesToOmit.contains($0) }
  }

  @inline(__always)
  public func omit<S: Sequence>(
    _ valuesToOmit: S
  ) -> Self
  where S.Element == Element, Element: Equatable {
    filter { !valuesToOmit.contains($0) }
  }
}
