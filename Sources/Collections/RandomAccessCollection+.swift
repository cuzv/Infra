extension RandomAccessCollection {
  public func indexed() -> [(offset: Int, element: Element)] {
    Array(enumerated())
  }
}
