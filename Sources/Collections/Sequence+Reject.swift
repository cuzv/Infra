public extension Sequence {
  @inline(__always)
  func reject<T>(_ type: T.Type) -> [Element] {
    filter { !($0 is T) }
  }

  @inline(__always)
  func reject(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  func reject(
    _ valuesToReject: Element...
  ) -> [Element] where Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  func reject(
    _ valuesToReject: some Sequence<Element>
  ) -> [Element] where Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  func reject<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) != value }
  }
}

public extension LazySequence {
  @inline(__always)
  func reject<T>(
    _ type: T.Type
  ) -> LazyFilterSequence<Elements> {
    filter { !($0 is T) }
  }

  @inline(__always)
  func reject(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  func reject(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> LazyFilterSequence<Elements> {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  func reject(
    _ valuesToReject: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  func reject(
    _ valuesToReject: some Sequence<Element>
  ) -> LazyFilterSequence<Elements>
    where Element: Equatable
  {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  func reject<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> LazyFilterSequence<Elements> where Value: Equatable {
    filter { transform($0) != value }
  }

  @inline(__always)
  func reject<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) != value }
  }
}

public extension LazyMapSequence {
  @inline(__always)
  func reject<T>(
    _ type: T.Type
  ) -> LazyFilterSequence<Elements> {
    filter { !($0 is T) }
  }

  @inline(__always)
  func reject(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  func reject(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> LazyFilterSequence<Elements> {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  func reject(
    _ valuesToReject: Element...
  ) -> LazyFilterSequence<Elements> where Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  func reject(
    _ valuesToReject: some Sequence<Element>
  ) -> LazyFilterSequence<Elements>
    where Element: Equatable
  {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  func reject<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> LazyFilterSequence<Elements> where Value: Equatable {
    filter { transform($0) != value }
  }

  @inline(__always)
  func reject<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) != value }
  }
}

public extension LazyFilterSequence {
  @inline(__always)
  func reject<T>(
    _ type: T.Type
  ) -> Self {
    filter { !($0 is T) }
  }

  @inline(__always)
  func reject(
    _ notIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    try filter { try !notIncluded($0) }
  }

  @inline(__always)
  func reject(
    _ notIncluded: @escaping (Element) -> Bool
  ) -> Self {
    filter { !notIncluded($0) }
  }

  @inline(__always)
  func reject(
    _ valuesToReject: Element...
  ) -> Self where Element: Equatable {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  func reject(
    _ valuesToReject: some Sequence<Element>
  ) -> Self
    where Element: Equatable
  {
    filter { !valuesToReject.contains($0) }
  }

  @inline(__always)
  func reject<Value>(
    on transform: @escaping (Element) -> Value, equals value: Value
  ) -> Self where Value: Equatable {
    filter { transform($0) != value }
  }

  @inline(__always)
  func reject<Value>(
    on transform: (Element) throws -> Value, equals value: Value
  ) rethrows -> [Element] where Value: Equatable {
    try filter { try transform($0) != value }
  }
}
