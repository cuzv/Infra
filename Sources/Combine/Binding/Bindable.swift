#if !(os(iOS) && (arch(i386) || arch(arm)))
import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public protocol Bindable {
  mutating func store(_ subscription: AnyCancellable)
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Bindable where Self: AnyObject {
  public func store(_ subscription: AnyCancellable) {
    subscription.store(in: &subscriptions)
  }

  public var subscriptions: Set<AnyCancellable> {
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

extension NSObject: Bindable {}
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension CurrentValueSubject: Bindable {}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension PassthroughSubject: Bindable {}
#endif
