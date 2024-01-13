public extension RandomAccessCollection {
  func indexed() -> [(offset: Int, element: Element)] {
    Array(enumerated())
  }
}
