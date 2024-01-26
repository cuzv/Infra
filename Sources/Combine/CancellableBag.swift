#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public final class CancellableBag {
  var subscriptions = Set<AnyCancellable>([])

  public init() {}

  public func cancel() {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions = []
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension AnyCancellable {
  func store(in bag: CancellableBag) {
    store(in: &bag.subscriptions)
  }
}
#endif
