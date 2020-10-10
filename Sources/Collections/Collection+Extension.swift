extension Collection {
    public func chunked(by distance: Int) -> [[Element]] {
        precondition(distance > 0, "distance must be greater than 0")

        var index = startIndex
        let iterator: AnyIterator<[Element]> = AnyIterator {
            let endIndex = self.endIndex
            let newIndex = self.index(index, offsetBy: distance, limitedBy: endIndex) ?? endIndex
            defer { index = newIndex }
            let range = index ..< newIndex
            return index != endIndex ? Array(self[range]) : nil
        }

        return Array(iterator)
    }
}

extension Collection {
    @inline(__always)
    public func toTuple2() -> (Element, Element) {
        (self[startIndex], self[index(after: startIndex)])
    }

    @inline(__always)
    public func toTuple3() -> (Element, Element, Element) {
        (self[startIndex], self[index(after: startIndex)], self[index(startIndex, offsetBy: 2)])
    }

    @inline(__always)
    public func toTuple4() -> (Element, Element, Element, Element) {
        (self[startIndex], self[index(after: startIndex)], self[index(startIndex, offsetBy: 2)], self[index(startIndex, offsetBy: 3)])
    }

    @inline(__always)
    public func toTuple5() -> (Element, Element, Element, Element, Element) {
        (self[startIndex], self[index(after: startIndex)], self[index(startIndex, offsetBy: 2)], self[index(startIndex, offsetBy: 3)], self[index(startIndex, offsetBy: 4)])
    }

    @inline(__always)
    public func toTuple6() -> (Element, Element, Element, Element, Element, Element) {
        (self[startIndex], self[index(after: startIndex)], self[index(startIndex, offsetBy: 2)], self[index(startIndex, offsetBy: 3)], self[index(startIndex, offsetBy: 4)], self[index(startIndex, offsetBy: 5)])
    }
}
