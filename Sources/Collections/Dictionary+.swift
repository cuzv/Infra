public extension Dictionary {
  @inline(__always)
  static func += (lhs: inout Dictionary, rhs: Dictionary) {
    lhs.merge(rhs, uniquingKeysWith: { $1 })
  }

  @inline(__always)
  static func += (lhs: inout Dictionary?, rhs: Dictionary) {
    if lhs == nil {
      lhs = rhs
    } else {
      lhs?.merge(rhs, uniquingKeysWith: { $1 })
    }
  }

  @inline(__always)
  static func += (lhs: Dictionary, rhs: Dictionary) -> Dictionary {
    lhs.merging(rhs, uniquingKeysWith: { $1 })
  }

  @inline(__always)
  static func += (lhs: Dictionary?, rhs: Dictionary) -> Dictionary? {
    lhs ?? [:].merging(rhs, uniquingKeysWith: { $1 })
  }

  @inline(__always)
  func has(key: Key) -> Bool {
    index(forKey: key) != nil
  }

  @inline(__always)
  var trimmed: Self {
    .init(uniqueKeysWithValues: compactMap { key, value -> Element? in
      if let value = value as? String, value.isEmpty {
        return nil
      }
      if let value = value as? Data, value.isEmpty {
        return nil
      }
      return (key, value)
    })
  }
}

public extension Dictionary {
  subscript(
    key: Key,
    setIfNil defaultValue: @autoclosure () -> Value
  ) -> Value {
    mutating get {
      if let value = self[key] {
        return value
      } else {
        let value = defaultValue()
        self[key] = value
        return value
      }
    }
  }
}
