extension Sequence {
  /// Returns a new stable array containing the elements of this sequence that do not occur in the given sequence.
  ///
  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  public func subtracting<Other: Sequence, Subject: Hashable>(
    _ other: Other,
    on projection: (Element) throws -> Subject
  ) rethrows -> [Element] where Other.Element == Element {
    var seen = try Set<Subject>(other.map(projection))
    return try filter {
      try seen.insert(projection($0)).inserted
    }
  }

  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  public func removingDuplicates<Subject: Hashable>(
    on projection: (Element) throws -> Subject
  ) rethrows -> [Iterator.Element] {
    try subtracting([], on: projection)
  }
}

extension Sequence where Iterator.Element: Hashable {
  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  public var uniqued: [Iterator.Element] {
    removingDuplicates()
  }

  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  public func removingDuplicates() -> [Iterator.Element] {
    removingDuplicates(on: \.hashValue)
  }

  /// Returns a new stable array containing the elements of this sequence that do not occur in the given sequence.
  ///
  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  public func subtracting<S>(_ other: S) -> [Iterator.Element]
  where S: Sequence, S.Element == Element {
    subtracting(other, on: \.hashValue)
  }
}
