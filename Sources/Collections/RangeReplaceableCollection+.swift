extension RangeReplaceableCollection {
  /// Shuffles this Collection in place
  public mutating func shuffle() {
    self = .init(shuffled())
  }

  public mutating func prepend(_ newElement: Element) {
    insert(newElement, at: startIndex)
  }
}

extension RangeReplaceableCollection where Element: Equatable {
  @discardableResult
  public mutating func removeFirst(_ element: Element) -> Bool {
    let index = firstIndex { $0 == element }
    if let index = index {
      remove(at: index)
      return true
    } else {
      return false
    }
  }

  @discardableResult
  public mutating func replaceFirst(_ element: Element, with newElement: Element) -> Bool {
    let index = firstIndex { $0 == element }
    if let index = index {
      remove(at: index)
      insert(newElement, at: index)
      return true
    } else {
      return false
    }
  }

  public mutating func removeAll(_ element: Element) {
    removeAll { $0 == element }
  }

  public mutating func removeDuplicates() {
    self = .init(reduce(into: [Element]()) {
      if !$0.contains($1) {
        $0.append($1)
      }
    })
  }
}
