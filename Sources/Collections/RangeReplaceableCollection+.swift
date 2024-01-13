public extension RangeReplaceableCollection {
  /// Shuffles this Collection in place
  mutating func shuffle() {
    self = .init(shuffled())
  }

  mutating func prepend(_ newElement: Element) {
    insert(newElement, at: startIndex)
  }
}

public extension RangeReplaceableCollection where Element: Equatable {
  @discardableResult
  mutating func removeFirst(_ element: Element) -> Bool {
    let index = firstIndex { $0 == element }
    if let index {
      remove(at: index)
      return true
    } else {
      return false
    }
  }

  @discardableResult
  mutating func replaceFirst(
    _ element: Element,
    with newElement: Element
  ) -> Bool {
    let index = firstIndex { $0 == element }
    if let index {
      remove(at: index)
      insert(newElement, at: index)
      return true
    } else {
      return false
    }
  }

  mutating func removeAll(_ element: Element) {
    removeAll { $0 == element }
  }

  mutating func removeDuplicates() {
    self = .init(reduce(into: [Element]()) {
      if !$0.contains($1) {
        $0.append($1)
      }
    })
  }
}
