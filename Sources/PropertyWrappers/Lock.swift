import Dispatch

@propertyWrapper
public struct Lock<Value> {
    private let queue = DispatchQueue(label: "Locking", attributes: .concurrent)
    private var value: Value

    public init(wrappedValue value: Value) {
        self.value = value
    }

    public var wrappedValue: Value {
        get {
            queue.sync { value }
        }
        set {
            queue.sync(flags: .barrier) {
                self.value = newValue
            }
        }
    }

    public mutating func mutate(_ mutation: (inout Value) throws -> Void) rethrows {
        try queue.sync(flags: .barrier) {
            try mutation(&value)
        }
    }
}
