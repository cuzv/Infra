#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension CombineExtensions {
  enum SubscriptionStatus {
    case awaitingSubscription
    case subscribed(Subscription)
    case terminal
  }
}
#endif
