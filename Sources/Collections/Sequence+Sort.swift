extension Sequence {
  @inlinable
  public func sorted<T>(
    by transform: (Element) throws -> T
  ) rethrows -> [Element] where T: Comparable {
    try sorted { lhs, rhs in
      (try transform(lhs)) < (try transform(rhs))
    }
  }

  @inlinable
  public func sorted<T>(
    by transform: (Element) throws -> T?
  ) rethrows -> [Element] where T: Comparable {
    try sorted { lhs, rhs in
      if let lv = (try transform(lhs)), let rv = (try transform(rhs)) {
        return lv < rv
      } else {
        return true
      }
    }
  }

  @inlinable
  public func sorted<M, S>(
    by majorTransform: (Element) throws -> M,
    or secondaryTransform: (Element) throws -> S
  ) rethrows -> [Element] where M: Comparable, S: Comparable {
    try sorted { lhs, rhs in
      let lm = try majorTransform(lhs)
      let rm = try majorTransform(rhs)
      if lm == rm {
        let ls = try secondaryTransform(lhs)
        let rs = try secondaryTransform(rhs)
        return ls < rs
      } else {
        return lm < rm
      }
    }
  }
}
