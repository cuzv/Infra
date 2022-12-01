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
