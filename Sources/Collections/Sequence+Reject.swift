extension Sequence {
  @inline(__always)
  public func reject<T>(_ type: T.Type) -> [Element] {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func reject(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func reject(
    _ valuesToReject: Element...
  ) -> [Element] where Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  public func reject<S: Sequence>(
    _ valuesToReject: S
  ) -> [Element] where S.Element == Element, Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }
}

extension LazySequence {
  @inline(__always)
  public func reject<T>(
    _ type: T.Type
  ) -> LazyFilterSequence<Elements> {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func reject(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func reject(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> LazyFilterSequence<Elements> {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  public func reject(
    _ valuesToReject: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  public func reject<S: Sequence>(
    _ valuesToReject: S
  ) -> LazyFilterSequence<Elements>
  where S.Element == Element, Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }
}

extension LazyMapSequence {
  @inline(__always)
  public func reject<T>(
    _ type: T.Type
  ) -> LazyFilterSequence<Elements> {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func reject(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func reject(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> LazyFilterSequence<Elements> {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  public func reject(
    _ valuesToReject: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  public func reject<S: Sequence>(
    _ valuesToReject: S
  ) -> LazyFilterSequence<Elements>
  where S.Element == Element, Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }
}

extension LazyFilterSequence {
  @inline(__always)
  public func reject<T>(
    _ type: T.Type
  ) -> Self {
    filter { !($0 is T) }
  }

  @inline(__always)
  public func reject(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  public func reject(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> Self {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  public func reject(
    _ valuesToReject: Element...
  ) -> Self where Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  public func reject<S: Sequence>(
    _ valuesToReject: S
  ) -> Self
  where S.Element == Element, Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }
}
