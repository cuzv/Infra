/// https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#ref--box
@propertyWrapper
public class Box<Value> {
    public var wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public var projectedValue: Ref<Value> {
        .init(
            read: { self.wrappedValue },
            write: { self.wrappedValue = $0 }
        )
    }
}

/// https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#ref--box
@propertyWrapper
public struct Ref<Value> {
    let read: () -> Value
    let write: (Value) -> Void

    public var wrappedValue: Value {
        get { read() }
        nonmutating set { write(newValue) }
    }

    public subscript<Result>(dynamicMember keyPath: WritableKeyPath<Value, Result>) -> Ref<Result> {
        .init(
            read: { self.wrappedValue[keyPath: keyPath] },
            write: { self.wrappedValue[keyPath: keyPath] = $0 }
        )
    }
}
