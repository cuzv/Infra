@propertyWrapper
public struct DebugOverridable<Value> {
    #if DEBUG
    public var wrappedValue: Value
    #else
    public let wrappedValue: Value
    #endif

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}
