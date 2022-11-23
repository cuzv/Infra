#if !(os(iOS) && (arch(i386) || arch(arm)))
import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Subscribers {
  public final class ContinuousSink<Input, Failure: Error>: Subscriber, Cancellable, CustomStringConvertible, CustomReflectable, CustomPlaygroundDisplayConvertible {
    typealias SubscriptionStatus = CombineExtensions.SubscriptionStatus

    public let receiveValue: (Input) -> Void
    public let receiveCompletion: (Subscribers.Completion<Failure>) -> Void
    private var status = SubscriptionStatus.awaitingSubscription

    public var description: String { "ContinuousSink" }
    public var customMirror: Mirror { Mirror(self, children: EmptyCollection()) }
    public var playgroundDescription: Any { description }

    public init(
      receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void,
      receiveValue: @escaping ((Input) -> Void)
    ) {
      self.receiveCompletion = receiveCompletion
      self.receiveValue = receiveValue
    }

    public func receive(subscription: Subscription) {
      switch status {
      case .subscribed, .terminal:
        subscription.cancel()
      case .awaitingSubscription:
        status = .subscribed(subscription)
        subscription.request(.max(1))
      }
    }

    public func receive(_ value: Input) -> Subscribers.Demand {
      receiveValue(value)
      return .max(1)
    }

    public func receive(completion: Subscribers.Completion<Failure>) {
      receiveCompletion(completion)
      status = .terminal
    }

    public func cancel() {
      if case let .subscribed(subscription) = status {
        subscription.cancel()
        status = .terminal
      }
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Publisher {
  public func continuousSink(
    receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void,
    receiveValue: @escaping ((Output) -> Void)
  ) -> AnyCancellable {
    let subscriber = Subscribers.ContinuousSink<Output, Failure>(
      receiveCompletion: receiveCompletion,
      receiveValue: receiveValue
    )
    subscribe(subscriber)
    return AnyCancellable(subscriber)
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Publisher where Failure == Never {
  public func continuousSink(
    receiveValue: @escaping (Output) -> Void
  ) -> AnyCancellable {
    let subscriber = Subscribers.ContinuousSink<Output, Failure>(
      receiveCompletion: { _ in },
      receiveValue: receiveValue
    )
    subscribe(subscriber)
    return AnyCancellable(subscriber)
  }
}
#endif
