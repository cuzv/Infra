public extension Sequence {
  /// Returns a new stable array containing the elements of this sequence that do not occur in the given sequence.
  ///
  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  func subtracting<Subject: Hashable>(
    _ other: some Sequence<Element>,
    on projection: (Element) throws -> Subject
  ) rethrows -> [Element] {
    var seen = try Set<Subject>(other.map(projection))
    return try filter {
      try seen.insert(projection($0)).inserted
    }
  }

  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  func removingDuplicates(
    on projection: (Element) throws -> some Hashable
  ) rethrows -> [Iterator.Element] {
    try subtracting([], on: projection)
  }
}

public extension Sequence where Iterator.Element: Hashable {
  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  var uniqued: [Iterator.Element] {
    removingDuplicates()
  }

  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  func removingDuplicates() -> [Iterator.Element] {
    removingDuplicates(on: \.hashValue)
  }

  /// Returns a new stable array containing the elements of this sequence that do not occur in the given sequence.
  ///
  /// - Complexity: O(*n*), where *n* is the length of this sequence.
  @inlinable
  func subtracting(_ other: some Sequence<Element>) -> [Iterator.Element] {
    subtracting(other, on: \.hashValue)
  }
}
