public protocol Copyable: AnyObject {
    func copy() -> Self
}

/// https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#copy-on-write
@propertyWrapper
public struct CopyOnWrite<Value: Copyable> {
    public private(set) var wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public var projectedValue: Value {
        mutating get {
            if !isKnownUniquelyReferenced(&wrappedValue) {
                wrappedValue = wrappedValue.copy()
            }
            return wrappedValue
        }
        set {
            wrappedValue = newValue
        }
    }
}
