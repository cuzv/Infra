extension MutableCollection where Self: RandomAccessCollection {
  public mutating func sort<T>(
    by transform: (Element) throws -> T
  ) rethrows where T: Comparable {
    try sort { lhs, rhs in
      (try transform(lhs)) < (try transform(rhs))
    }
  }

  public mutating func sort<T>(
    by transform: (Element) throws -> T?
  ) rethrows where T: Comparable {
    try sort { lhs, rhs in
      if let lv = (try transform(lhs)), let rv = (try transform(rhs)) {
        return lv < rv
      } else {
        return true
      }
    }
  }

  public mutating func sort<M, S>(
    by majorTransform: (Element) throws -> M,
    or secondaryTransform: (Element) throws -> S
  ) rethrows where M: Comparable, S: Comparable {
    try sort { lhs, rhs in
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
