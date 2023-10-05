#if !(os(iOS) && (arch(i386) || arch(arm)))
import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Subscribers {
  public final class Binder<Target: BindingProvider & AnyObject, Input> {
    private(set) weak var target: Target?
    private let receiveCompletion: (Target, Completion<Never>) -> Void
    private let receiveValue: (Target, Input) -> Void
    private var subscription: Subscription?

    public init(
      target: Target,
      receiveCompletion: @escaping (Target, Completion<Never>) -> Void = { _, _ in },
      receiveValue: @escaping (Target, Input) -> Void
    ) {
      self.target = target
      self.receiveCompletion = receiveCompletion
      self.receiveValue = receiveValue
    }

    private func withTarget(_ body: (Target) -> Void) {
      if let target = target {
        body(target)
      } else {
        cancel()
      }
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Subscribers.Binder where Input == Void {
  public convenience init(
    target: Target,
    receiveCompletion: @escaping (Target, Subscribers.Completion<Failure>) -> Void = { _, _ in },
    receiveValue: @escaping (Target) -> Void
  ) {
    self.init(
      target: target,
      receiveCompletion: receiveCompletion,
      receiveValue: { target, _ in receiveValue(target) }
    )
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Subscribers.Binder where Input == Never {
  public convenience init(
    target: Target,
    receiveCompletion: @escaping (Target, Subscribers.Completion<Failure>) -> Void
  ) {
    self.init(
      target: target,
      receiveCompletion: receiveCompletion,
      receiveValue: { _, _ in }
    )
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Subscribers.Binder: Subscriber {
  public func receive(subscription: Subscription) {
    if target != nil {
      subscription.request(.unlimited)
      self.subscription = subscription
    } else {
      subscription.cancel()
    }
  }

  public func receive(_ input: Input) -> Subscribers.Demand {
    withTarget { receiveValue($0, input) }
    return .max(1)
  }

  public func receive(completion: Subscribers.Completion<Never>) {
    withTarget { receiveCompletion($0, completion) }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Subscribers.Binder: Cancellable {
  public func cancel() {
    subscription?.cancel()
    subscription = nil
    target = nil
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Publisher where Failure == Never {
  @discardableResult
  public func bind<Target: BindingProvider & AnyObject>(
    to sink: Subscribers.Binder<Target, Output>
  ) -> AnyCancellable {
    guard let target = sink.target else { return AnyCancellable({}) }
    let cancellable = AnyCancellable(sink)
    target.store(cancellable)
    subscribe(sink)
    return cancellable
  }

  @discardableResult
  public func bind<Target: BindingProvider & AnyObject>(
    to sink: Subscribers.Binder<Target, Output?>
  ) -> AnyCancellable {
    map(Optional.some).bind(to: sink)
  }

  @discardableResult
  public func bind(to subject: CurrentValueSubject<Output, Never>) -> AnyCancellable {
    let cancellable = subscribe(subject)
    subject.store(cancellable)
    return cancellable
  }

  @discardableResult
  public func bind(to subject: CurrentValueSubject<Output?, Never>) -> AnyCancellable {
    map(Optional.some).bind(to: subject)
  }

  @discardableResult
  public func bind(to subject: PassthroughSubject<Output, Never>) -> AnyCancellable {
    let cancellable = subscribe(subject)
    subject.store(cancellable)
    return cancellable
  }

  @discardableResult
  public func bind(to subject: PassthroughSubject<Output?, Never>) -> AnyCancellable {
    map(Optional.some).bind(to: subject)
  }

  @discardableResult
  public func bind<Target: BindingProvider & AnyObject>(
    to target: Target,
    action: @escaping (Target, Output) -> Void
  ) -> AnyCancellable {
    bind(to: .init(target: target, receiveValue: action))
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Subscribers.Binder: UnidirectionalBinding {
  @discardableResult
  public static func => <P>(
    source: P,
    subscriber: Subscribers.Binder<Target, Input>
  ) -> AnyCancellable where P: Publisher, Input == P.Output, Failure == P.Failure {
    source.bind(to: subscriber)
  }
}
#endif
