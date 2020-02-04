extension Sequence {
    @inline(__always)
    public func map<T>(_ type: T.Type) -> [T?] {
        map { $0 as? T }
    }

    @inline(__always)
    public func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        map { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func compactMap<ElementOfResult>(_ type: ElementOfResult.Type) -> [ElementOfResult] {
        compactMap { $0 as? ElementOfResult }
    }

    @inline(__always)
    public func compactMap<ElementOfResult>(_ keyPath: KeyPath<Element, ElementOfResult?>) -> [ElementOfResult] {
        compactMap { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func flatMap<SegmentOfResult>(_ keyPath: KeyPath<Element, SegmentOfResult>) -> [SegmentOfResult.Element] where SegmentOfResult: Sequence {
        flatMap { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func filter<T>(_ type: T.Type) -> [Element] {
        filter { $0 is T }
    }

    @inline(__always)
    public func filter(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
        filter { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func ignore<T>(_ type: T.Type) -> [Element] {
        filter { !($0 is T) }
    }

    @inline(__always)
    public func ignore(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
        filter { !$0[keyPath: keyPath] }
    }

    @inline(__always)
    public func ignore(_ notIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        try filter { try !notIncluded($0) }
    }
}

extension Sequence where Element: Equatable {
    @inline(__always)
    public func filter(_ valuesToFilter: Element...) -> [Element] {
        filter { valuesToFilter.contains($0) }
    }

    @inline(__always)
    public func filter<Sequence: Swift.Sequence>(_ valuesToFilter: Sequence) -> [Element] where Sequence.Element == Element {
        filter { valuesToFilter.contains($0) }
    }

    @inline(__always)
    public func ignore(_ valuesToIgnore: Element...) -> [Element] {
        filter { !valuesToIgnore.contains($0) }
    }

    @inline(__always)
    public func ignore<Sequence: Swift.Sequence>(_ valuesToIgnore: Sequence) -> [Element] where Sequence.Element == Element {
        filter { !valuesToIgnore.contains($0) }
    }
}

extension LazySequence {
    @inline(__always)
    public func map<U>(_ type: U.Type) -> LazyMapSequence<Base, U?> {
        map { $0 as? U }
    }

    @inline(__always)
    public func map<U>(_ keyPath: KeyPath<Element, U>) -> LazyMapSequence<Base, U> {
        map { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func compactMap<ElementOfResult>(_ type: ElementOfResult.Type) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Base, ElementOfResult?>>, ElementOfResult> {
        compactMap { $0 as? ElementOfResult }
    }

    @inline(__always)
    public func compactMap<ElementOfResult>(_ keyPath: KeyPath<Element, ElementOfResult?>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Base, ElementOfResult?>>, ElementOfResult> {
        compactMap { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func flatMap<SegmentOfResult>(_ keyPath: KeyPath<Element, SegmentOfResult>) -> LazySequence<FlattenSequence<LazyMapSequence<Base, SegmentOfResult>>> where SegmentOfResult: Sequence {
        flatMap { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func filter<T>(_ type: T.Type) -> LazyFilterSequence<Base> {
        filter { $0 is T }
    }

    @inline(__always)
    public func filter(_ keyPath: KeyPath<Element, Bool>) -> LazyFilterSequence<Base> {
        return filter { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func ignore<T>(_ type: T.Type) -> LazyFilterSequence<Base> {
        filter { !($0 is T) }
    }

    @inline(__always)
    public func ignore(_ keyPath: KeyPath<Element, Bool>) -> LazyFilterSequence<Base> {
        filter { !$0[keyPath: keyPath] }
    }

    @inline(__always)
    public func ignore(_ notIncluded: @escaping (Element) -> Bool) -> LazyFilterSequence<Base> {
        filter { !notIncluded($0) }
    }
}

extension LazySequence where Element: Equatable {
    @inline(__always)
    public func filter(_ valuesToFilter: Element...) -> LazyFilterSequence<Base> {
        filter { valuesToFilter.contains($0) }
    }

    @inline(__always)
    public func filter<Sequence: Swift.Sequence>(_ valuesToFilter: Sequence) -> LazyFilterSequence<Base> where Sequence.Element == Element {
        filter { valuesToFilter.contains($0) }
    }

    @inline(__always)
    public func ignore(_ valuesToIgnore: Element...) -> LazyFilterSequence<Base> {
        filter { !valuesToIgnore.contains($0) }
    }

    @inline(__always)
    public func ignore<Sequence: Swift.Sequence>(_ valuesToIgnore: Sequence) -> LazyFilterSequence<Base> where Sequence.Element == Element {
        filter { !valuesToIgnore.contains($0) }
    }
}

extension LazyMapSequence {
    @inline(__always)
    public func map<U>(_ type: U.Type) -> LazyMapSequence<Base, U?> {
        map { $0 as? U }
    }

    @inline(__always)
    public func map<U>(_ keyPath: KeyPath<Element, U>) -> LazyMapSequence<Base, U> {
        map { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func compactMap<ElementOfResult>(_ type: ElementOfResult.Type) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<LazyMapSequence<Base, Element>, ElementOfResult?>>, ElementOfResult> {
        compactMap { $0 as? ElementOfResult }
    }

    @inline(__always)
    public func compactMap<ElementOfResult>(_ keyPath: KeyPath<Element, ElementOfResult?>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<LazyMapSequence<Base, Element>, ElementOfResult?>>, ElementOfResult> {
        compactMap { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func flatMap<SegmentOfResult>(_ keyPath: KeyPath<Element, SegmentOfResult>) -> LazySequence<FlattenSequence<LazyMapSequence<LazyMapSequence<Base, Element>, SegmentOfResult>>> where SegmentOfResult: Sequence {
        flatMap { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func filter<T>(_ type: T.Type) -> LazyFilterSequence<LazyMapSequence<Base, Element>> {
        filter { $0 is T }
    }

    @inline(__always)
    public func filter(_ keyPath: KeyPath<Element, Bool>) -> LazyFilterSequence<LazyMapSequence<Base, Element>> {
        filter { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func ignore<T>(_ type: T.Type) -> LazyFilterSequence<LazyMapSequence<Base, Element>> {
        filter { !($0 is T) }
    }

    @inline(__always)
    public func ignore(_ keyPath: KeyPath<Element, Bool>) -> LazyFilterSequence<LazyMapSequence<Base, Element>> {
        filter { !$0[keyPath: keyPath] }
    }

    @inline(__always)
    public func ignore(_ notIncluded: @escaping (Element) -> Bool) -> LazyFilterSequence<LazyMapSequence<Base, Element>> {
        filter { !notIncluded($0) }
    }
}

extension LazyMapSequence where Element: Equatable {
    @inline(__always)
    public func filter(_ valuesToFilter: Element...) -> LazyFilterSequence<LazyMapSequence<Base, Element>> {
        filter { valuesToFilter.contains($0) }
    }

    @inline(__always)
    public func filter<Sequence: Swift.Sequence>(_ valuesToFilter: Sequence) -> LazyFilterSequence<LazyMapSequence<Base, Element>> where Sequence.Element == Element {
        filter { valuesToFilter.contains($0) }
    }

    @inline(__always)
    public func ignore(_ valuesToIgnore: Element...) -> LazyFilterSequence<LazyMapSequence<Base, Element>> {
        filter { !valuesToIgnore.contains($0) }
    }

    @inline(__always)
    public func ignore<Sequence: Swift.Sequence>(_ valuesToIgnore: Sequence) -> LazyFilterSequence<LazyMapSequence<Base, Element>> where Sequence.Element == Element {
        filter { !valuesToIgnore.contains($0) }
    }
}

extension LazyFilterSequence {
    @inline(__always)
    public func map<U>(_ type: U.Type) -> LazyMapSequence<LazyFilterSequence<Base>, U?> {
        map { $0 as? U }
    }

    @inline(__always)
    public func map<U>(_ keyPath: KeyPath<Element, U>) -> LazyMapSequence<LazyFilterSequence<Base>, U> {
        map { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func compactMap<ElementOfResult>(_ keyPath: KeyPath<Element, ElementOfResult?>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<LazyFilterSequence<Base>, ElementOfResult?>>, ElementOfResult> {
        compactMap { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func compactMap<ElementOfResult>(_ type: ElementOfResult.Type) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<LazyFilterSequence<Base>, ElementOfResult?>>, ElementOfResult> {
        compactMap { $0 as? ElementOfResult }
    }

    @inline(__always)
    public func flatMap<SegmentOfResult>(_ keyPath: KeyPath<Element, SegmentOfResult>) -> LazySequence<FlattenSequence<LazyMapSequence<LazyFilterSequence<Base>, SegmentOfResult>>> where SegmentOfResult: Sequence {
        flatMap { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func filter<T>(_ type: T.Type) -> LazyFilterSequence<Base> {
        filter { $0 is T }
    }

    @inline(__always)
    public func filter(_ keyPath: KeyPath<Element, Bool>) -> LazyFilterSequence<Base> {
        filter { $0[keyPath: keyPath] }
    }

    @inline(__always)
    public func ignore<T>(_ type: T.Type) -> LazyFilterSequence<Base> {
        filter { !($0 is T) }
    }

    @inline(__always)
    public func ignore(_ keyPath: KeyPath<Element, Bool>) -> LazyFilterSequence<Base> {
        filter { !$0[keyPath: keyPath] }
    }

    @inline(__always)
    public func ignore(_ notIncluded: @escaping (Element) -> Bool) -> LazyFilterSequence<Base> {
        filter { !notIncluded($0) }
    }
}

extension LazyFilterSequence where Element: Equatable {
    @inline(__always)
    public func filter(_ valuesToFilter: Element...) -> LazyFilterSequence<Base> {
        filter { valuesToFilter.contains($0) }
    }

    @inline(__always)
    public func filter<Sequence: Swift.Sequence>(_ valuesToFilter: Sequence) -> LazyFilterSequence<Base> where Sequence.Element == Element {
        filter { valuesToFilter.contains($0) }
    }

    @inline(__always)
    public func ignore(_ valuesToIgnore: Element...) -> LazyFilterSequence<Base> {
        filter { !valuesToIgnore.contains($0) }
    }

    @inline(__always)
    public func ignore<Sequence: Swift.Sequence>(_ valuesToIgnore: Sequence) -> LazyFilterSequence<Base> where Sequence.Element == Element {
        filter { !valuesToIgnore.contains($0) }
    }
}

extension Sequence {
    public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        sorted { a, b in
            let lhs = a[keyPath: keyPath]
            let rhs = b[keyPath: keyPath]
            return ascending ? lhs < rhs : lhs > rhs
        }
    }

    public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T?>, ascending: Bool = true) -> [Element] {
        sorted { a, b in
            guard let lhs = a[keyPath: keyPath], let rhs = b[keyPath: keyPath] else { return false }
            return ascending ? lhs < rhs : lhs > rhs
        }
    }

    public func sorted<M: Comparable, S: Comparable>(by majorKeyPath: KeyPath<Element, M>, or secondaryKeyPath: KeyPath<Element, S>, ascending: Bool = true) -> [Element] {
        sorted { a, b in
            let lhs = a[keyPath: majorKeyPath]
            let rhs = b[keyPath: majorKeyPath]

            if lhs == rhs {
                let lhs = a[keyPath: secondaryKeyPath]
                let rhs = b[keyPath: secondaryKeyPath]
                return ascending ? lhs < rhs : lhs > rhs
            }

            return ascending ? lhs < rhs : lhs > rhs
        }
    }

    public func sorted<T: Comparable, S: Comparable>(by majorKeyPath: KeyPath<Element, T?>, or secondaryKeyPath: KeyPath<Element, S>, ascending: Bool = true) -> [Element] {
        sorted { a, b in
            guard let lhs = a[keyPath: majorKeyPath], let rhs = b[keyPath: majorKeyPath] else {
                let lhs = a[keyPath: secondaryKeyPath]
                let rhs = b[keyPath: secondaryKeyPath]
                return ascending ? lhs < rhs : lhs > rhs
            }

            if lhs == rhs {
                let lhs = a[keyPath: secondaryKeyPath]
                let rhs = b[keyPath: secondaryKeyPath]
                return ascending ? lhs < rhs : lhs > rhs
            }

            return ascending ? lhs < rhs : lhs > rhs
        }
    }
}
