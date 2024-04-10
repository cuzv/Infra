import Combine
import Foundation

// swiftformat:disable numberFormatting
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use Observed instead")
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use Observed instead")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use Observed instead")
@available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use Observed instead")
@available(macCatalyst, introduced: 13.0, deprecated: 100000.0, message: "Use Observed instead")
// swiftformat:enable numberFormatting
@propertyWrapper
public final class Observable<Value>: ObservableObject {
  @Published private var innerValue: Value

  public init(wrappedValue: Value) {
    _innerValue = Published(wrappedValue: wrappedValue)
  }

  public var wrappedValue: Value {
    get { innerValue }
    set { innerValue = newValue }
  }

  public var projectedValue: Observable {
    self
  }

  public var publisher: Published<Value>.Publisher {
    $innerValue
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
@propertyWrapper
public final class Observed<Value>: ObservableObject {
  @Published private var innerValue: Value

  public init(wrappedValue: Value) {
    _innerValue = Published(wrappedValue: wrappedValue)
  }

  public var wrappedValue: Value {
    get { innerValue }
    set { innerValue = newValue }
  }

  public var projectedValue: Observed {
    self
  }

  public var publisher: Published<Value>.Publisher {
    $innerValue
  }
}
