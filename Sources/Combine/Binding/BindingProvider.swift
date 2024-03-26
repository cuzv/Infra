#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public protocol BindingProvider {
  mutating func store(_ subscription: AnyCancellable)
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension BindingProvider where Self: AnyObject {
  func store(_ subscription: AnyCancellable) {
    subscription.store(in: &subscriptions)
  }

  var subscriptions: Set<AnyCancellable> {
    _read { yield subscriptionsBox.wrappedValue }
    set { subscriptionsBox.wrappedValue = newValue }
    _modify { yield &subscriptionsBox.wrappedValue }
  }

  var subscriptionsBox: Box<Set<AnyCancellable>> {
    let box: Box<Set<AnyCancellable>>
    if let object = objc_getAssociatedObject(self, &subscriptionsKey) as? Box<Set<AnyCancellable>> {
      box = object
    } else {
      box = Box(wrappedValue: .init())
      objc_setAssociatedObject(self, &subscriptionsKey, box, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    return box
  }
}

@nonobjc private var subscriptionsKey: Void?

extension NSObject: BindingProvider {}
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension CurrentValueSubject: BindingProvider {}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension PassthroughSubject: BindingProvider {}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension BindingProvider where Self: AnyObject  {
  func binding<Element>(
    _ publisher: any Publisher<Element, Never>,
    to keyPath: ReferenceWritableKeyPath<Self, Element>
  ) -> Self {
    publisher.assignWeakSafely(to: keyPath, on: self).store(in: &subscriptions)
    return self
  }
}
#endif
