extension Dictionary {
  @inline(__always)
  public static func += (lhs: inout Dictionary, rhs: Dictionary) {
    lhs.merge(rhs, uniquingKeysWith: { $1 })
  }

  @inline(__always)
  public static func += (lhs: inout Dictionary?, rhs: Dictionary) {
    if nil == lhs {
      lhs = rhs
    } else {
      lhs?.merge(rhs, uniquingKeysWith: { $1 })
    }
  }

  @inline(__always)
  public static func += (lhs: Dictionary, rhs: Dictionary) -> Dictionary {
    lhs.merging(rhs, uniquingKeysWith: { $1 })
  }

  @inline(__always)
  public static func += (lhs: Dictionary?, rhs: Dictionary) -> Dictionary? {
    lhs ?? [:].merging(rhs, uniquingKeysWith: { $1 })
  }

  @inline(__always)
  public func has(key: Key) -> Bool {
    nil != index(forKey: key)
  }
}

extension Dictionary {
  public subscript(key: Key, setIfNil defaultValue: @autoclosure () -> Value) -> Value {
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
