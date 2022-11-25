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
