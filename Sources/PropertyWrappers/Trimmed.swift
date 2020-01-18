/// https://nshipster.com/propertywrapper/#transforming-values-on-property-assignment
@propertyWrapper
public struct Trimmed {
    private var value: String = ""

    public var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
}
