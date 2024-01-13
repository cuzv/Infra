public extension Collection {
  func chunked(stride: Int) -> [[Element]] {
    precondition(stride > 0, "stride must be greater than 0")

    var index = startIndex
    let iterator: AnyIterator<[Element]> = AnyIterator {
      let endIndex = self.endIndex
      let newIndex = self.index(
        index, offsetBy: stride, limitedBy: endIndex
      ) ?? endIndex
      defer { index = newIndex }
      let range = index ..< newIndex
      return index != endIndex ? Array(self[range]) : nil
    }

    return Array(iterator)
  }
}

public extension Collection {
  @inline(__always)
  func toTuple2() -> (Element, Element) {
    (self[startIndex], self[index(after: startIndex)])
  }

  @inline(__always)
  func toTuple3() -> (Element, Element, Element) {
    (
      self[startIndex],
      self[index(after: startIndex)],
      self[index(startIndex, offsetBy: 2)]
    )
  }

  @inline(__always)
  func toTuple4() -> (Element, Element, Element, Element) {
    (
      self[startIndex],
      self[index(after: startIndex)],
      self[index(startIndex, offsetBy: 2)],
      self[index(startIndex, offsetBy: 3)]
    )
  }

  @inline(__always)
  func toTuple5() -> (Element, Element, Element, Element, Element) {
    (
      self[startIndex],
      self[index(after: startIndex)],
      self[index(startIndex, offsetBy: 2)],
      self[index(startIndex, offsetBy: 3)],
      self[index(startIndex, offsetBy: 4)]
    )
  }

  @inline(__always)
  func toTuple6() -> (Element, Element, Element, Element, Element, Element) {
    (
      self[startIndex],
      self[index(after: startIndex)],
      self[index(startIndex, offsetBy: 2)],
      self[index(startIndex, offsetBy: 3)],
      self[index(startIndex, offsetBy: 4)],
      self[index(startIndex, offsetBy: 5)]
    )
  }
}

public extension Collection {
  func choose(_ n: Int) -> ArraySlice<Element> {
    shuffled().prefix(n)
  }

  var randomlyHalf: ArraySlice<Element> {
    choose(Swift.max(1, count / 2))
  }
}

public extension Collection {
  subscript(safe value: Int) -> Element? {
    var index: Index = startIndex
    formIndex(&index, offsetBy: value)
    return count > value ? self[index] : nil
  }
}
