public extension MutableCollection where Self: RandomAccessCollection {
  mutating func sort(
    by transform: (Element) throws -> some Comparable
  ) rethrows {
    try sort { lhs, rhs in
      try (transform(lhs)) < transform(rhs)
    }
  }

  mutating func sort(
    by transform: (Element) throws -> (some Comparable)?
  ) rethrows {
    try sort { lhs, rhs in
      if let lv = try (transform(lhs)), let rv = try (transform(rhs)) {
        lv < rv
      } else {
        true
      }
    }
  }

  mutating func sort(
    by majorTransform: (Element) throws -> some Comparable,
    or secondaryTransform: (Element) throws -> some Comparable
  ) rethrows {
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
