public extension Sequence {
  @inline(__always)
  func filter<T>(_ type: T.Type) -> [Element] {
    filter { $0 is T }
  }

  @inline(__always)
  func filter<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) == value }
  }

  @inline(__always)
  func filter(
    _ valuesToFilter: Element...
  ) -> [Element] where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  func filter(
    _ valuesToFilter: some Sequence<Element>
  ) -> [Element] where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }
}

public extension LazySequence {
  @inline(__always)
  func filter<T>(_ type: T.Type) -> LazyFilterSequence<Base> {
    filter { $0 is T }
  }

  @inline(__always)
  func filter<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> LazyFilterSequence<Elements> where Value: Equatable {
    filter { transform($0) == value }
  }

  @inline(__always)
  func filter<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) == value }
  }

  @inline(__always)
  func filter(
    _ valuesToFilter: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  func filter(
    _ valuesToFilter: some Sequence<Element>
  ) -> LazyFilterSequence<Elements>
    where Element: Equatable
  {
    filter { valuesToFilter.contains($0) }
  }
}

public extension LazyMapSequence {
  @inline(__always)
  func filter<T>(_ type: T.Type) -> LazyFilterSequence<Elements> {
    filter { $0 is T }
  }

  @inline(__always)
  func filter<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> LazyFilterSequence<Elements> where Value: Equatable {
    filter { transform($0) == value }
  }

  @inline(__always)
  func filter<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) == value }
  }

  @inline(__always)
  func filter(
    _ valuesToFilter: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  func filter(
    _ valuesToFilter: some Sequence<Element>
  ) -> LazyFilterSequence<Elements>
    where Element: Equatable
  {
    filter { valuesToFilter.contains($0) }
  }
}

public extension LazyFilterSequence {
  @inline(__always)
  func filter<T>(_ type: T.Type) -> Self {
    filter { $0 is T }
  }

  @inline(__always)
  func filter<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> Self where Value: Equatable {
    filter { transform($0) == value }
  }

  @inline(__always)
  func filter<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) == value }
  }

  @inline(__always)
  func filter(
    _ valuesToFilter: Element...
  ) -> Self where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }

  @inline(__always)
  func filter(
    _ valuesToFilter: some Sequence<Element>
  ) -> Self where Element: Equatable {
    filter { valuesToFilter.contains($0) }
  }
}
