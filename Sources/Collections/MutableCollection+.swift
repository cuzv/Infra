public extension MutableCollection {
  mutating func safeSwap(from index: Index, to otherIndex: Index) {
    guard index != otherIndex else { return }
    guard startIndex ..< endIndex ~= index else { return }
    guard startIndex ..< endIndex ~= otherIndex else { return }
    swapAt(index, otherIndex)
  }
}
