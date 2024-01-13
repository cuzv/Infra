public extension Sequence {
  @inline(__always)
  func mutate(
    _ mutation: @escaping (inout Element) -> Void
  ) -> [Element] {
    map { output in
      var result = output
      mutation(&result)
      return result
    }
  }
}

public extension LazySequence {
  @inline(__always)
  func mutate(
    _ mutation: @escaping (inout Element) -> Void
  ) -> LazyMapSequence<Elements, Element> {
    map { output in
      var result = output
      mutation(&result)
      return result
    }
  }
}
