/// https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#proposed-solution
@propertyWrapper
public enum Lazy<Value> {
    case uninitialized(() -> Value)
    case initialized(Value)

    public init(wrappedValue: @autoclosure @escaping () -> Value) {
        self = .uninitialized(wrappedValue)
    }

    public init(body: @escaping () -> Value) {
        self = .uninitialized(body)
    }

    public var wrappedValue: Value {
        mutating get {
            switch self {
            case let .uninitialized(initializer):
                let value = initializer()
                self = .initialized(value)
                return value
            case let .initialized(value):
                return value
            }
        }
        set {
            self = .initialized(newValue)
        }
    }
}

extension Lazy {
    /// Reset the state back to "uninitialized" with a new,
    /// possibly-different initial value to be computed on the next access.
    public mutating func reset(_ newValue:  @autoclosure @escaping () -> Value) {
        self = .uninitialized(newValue)
    }
}
