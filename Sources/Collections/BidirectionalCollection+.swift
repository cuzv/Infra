extension BidirectionalCollection {
  public subscript(offset distance: Int) -> Element {
    let index = distance >= 0 ? startIndex : endIndex
    return self[indices.index(index, offsetBy: distance)]
  }
}
