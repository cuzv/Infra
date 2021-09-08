/// https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#delayed-initialization
@propertyWrapper
public struct DelayedMutable<Value> {
  private var value: Value?

  public var wrappedValue: Value {
    get {
      guard let value = value else {
        fatalError("property accessed before being initialized")
      }
      return value
    }
    set {
      value = newValue
    }
  }

  public init() {}

  /// "Reset" the wrapper so it can be initialized again.
  /// This can be useful if you want to free up resources held by the current value without assigning a new one right away.
  public mutating func reset() {
    value = nil
  }
}

/// https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#delayed-initialization
@propertyWrapper
public struct DelayedImmutable<Value> {
  private var _value: Value?

  public var wrappedValue: Value {
    get {
      guard let value = _value else {
        fatalError("property accessed before being initialized")
      }
      return value
    }

    // Perform an initialization, trapping if the
    // value is already initialized.
    set {
      if _value != nil {
        fatalError("property initialized twice")
      }
      _value = newValue
    }
  }

  public init() {}
}
