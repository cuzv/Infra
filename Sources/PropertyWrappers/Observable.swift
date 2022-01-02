import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
@propertyWrapper
public final class Observable<Value>: ObservableObject {
  @Published public var innerValue: Value

  public init(wrappedValue: Value) {
    _innerValue = Published(wrappedValue: wrappedValue)
  }

  public var wrappedValue: Value {
    get { innerValue }
    set { innerValue = newValue }
  }

  public var projectedValue: Published<Value>.Publisher {
    $innerValue
  }
}
