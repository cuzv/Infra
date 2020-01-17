extension Array {
    public mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex..<endIndex ~= index else { return }
        guard startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }

    mutating func prepend(_ newElement: Element) {
        insert(newElement, at: 0)
    }

    @discardableResult
    mutating func sort<T: Comparable>(by keyPath: KeyPath<Element, T?>, ascending: Bool = true) -> [Element] {
        self = sorted(by: keyPath, ascending: ascending)
        return self
    }

    @discardableResult
    mutating func sort<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        self = sorted(by: keyPath, ascending: ascending)
        return self
    }
}

extension Array where Element: Equatable {
    @discardableResult
    public mutating func remove(_ element: Element) -> Bool {
        let index = self.firstIndex { $0 == element }
        if let index = index {
            remove(at: index)
            return true
        } else {
            return false
        }
    }

    @discardableResult
    public mutating func replace(_ element: Element, with newElement: Element) -> Bool {
        let index = self.firstIndex { $0 == element }
        if let index = index {
            remove(at: index)
            insert(newElement, at: index)
            return true
        } else {
            return false
        }
    }
}

extension Array where Element: Equatable {
    @discardableResult
    public mutating func removeAll(_ item: Element) -> [Element] {
        removeAll(where: { $0 == item })
        return self
    }

    @discardableResult
    public mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }

    @discardableResult
    public mutating func removeDuplicates() -> [Element] {
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
        return self
    }

    public func removingDuplicates() -> [Element] {
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
}

extension Array where Element: Hashable {
    @discardableResult
    public mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        let items = Set(items)
        removeAll(where: { items.contains($0) })
        return self
    }
}
