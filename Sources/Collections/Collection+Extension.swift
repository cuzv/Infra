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
