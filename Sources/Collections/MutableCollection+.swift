extension MutableCollection {
    public mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex..<endIndex ~= index else { return }
        guard startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
}

extension MutableCollection where Self: RandomAccessCollection {
    public mutating func sort<T>(
        by keyPath: KeyPath<Element, T>
    ) where T: Comparable {
        sort { lhs, rhs in
            lhs[keyPath: keyPath] < rhs[keyPath: keyPath]
        }
    }

    public mutating func sort<T>(
        by keyPath: KeyPath<Element, T?>
    ) where T: Comparable {
        sort { lhs, rhs in
            if let lv = lhs[keyPath: keyPath], let rv = rhs[keyPath: keyPath] {
                return lv < rv
            } else {
                return true
            }
        }
    }

    public mutating func sort<M, S>(
        by majorKeyPath: KeyPath<Element, M>,
        backup secondaryKeyPath: KeyPath<Element, S>
    ) where M: Comparable, S: Comparable {
        sort { lhs, rhs in
            let lm = lhs[keyPath: majorKeyPath]
            let rm = rhs[keyPath: majorKeyPath]
            if lm == rm {
                let ls = lhs[keyPath: secondaryKeyPath]
                let rs = rhs[keyPath: secondaryKeyPath]
                return ls < rs
            } else {
                return lm < rm
            }
        }
    }
}
