///https://nshipster.com/propertywrapper/#constraining-values
@propertyWrapper
public struct Clamping<Value: Comparable> {
  private var value: Value
  private let range: ClosedRange<Value>

  public init(initialValue value: Value, _ range: ClosedRange<Value>) {
    precondition(range.contains(value))
    self.value = value
    self.range = range
  }

  public var wrappedValue: Value {
    get { value }
    set { value = min(max(range.lowerBound, newValue), range.upperBound) }
  }
}
