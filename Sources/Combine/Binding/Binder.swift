#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Subscribers {
  final class Binder<Target: BindingProvider & AnyObject, Input> {
    private(set) weak var target: Target?
    private let receiveOnMainQueue: Bool
    private let receiveCompletion: (Target, Completion<Never>) -> Void
    private let receiveValue: (Target, Input) -> Void
    private var subscription: Subscription?

    public init(
      target: Target,
      receiveOnMainQueue: Bool = false,
      receiveCompletion: @escaping (Target, Completion<Never>) -> Void = { _, _ in },
      receiveValue: @escaping (Target, Input) -> Void
    ) {
      self.target = target
      self.receiveOnMainQueue = receiveOnMainQueue
      self.receiveCompletion = receiveCompletion
      self.receiveValue = receiveValue
    }

    private func withTarget(_ body: @escaping (Target) -> Void) {
      if let target {
        if receiveOnMainQueue {
          DispatchQueue.main.safeAsync {
            body(target)
          }
        } else {
          body(target)
        }
      } else {
        cancel()
      }
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Subscribers.Binder where Input == Void {
  convenience init(
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
public extension Subscribers.Binder where Input == Never {
  convenience init(
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
    withTarget { self.receiveValue($0, input) }
    return .max(1)
  }

  public func receive(completion: Subscribers.Completion<Never>) {
    withTarget { self.receiveCompletion($0, completion) }
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
public extension Publisher where Failure == Never {
  @discardableResult
  func bind(
    to sink: Subscribers.Binder<some BindingProvider & AnyObject, Output>
  ) -> AnyCancellable {
    guard let target = sink.target else { return AnyCancellable {} }
    let cancellable = AnyCancellable(sink)
    target.store(cancellable)
    subscribe(sink)
    return cancellable
  }

  @discardableResult
  func bind(
    to sink: Subscribers.Binder<some BindingProvider & AnyObject, Output?>
  ) -> AnyCancellable {
    map(Optional.some).bind(to: sink)
  }

  @discardableResult
  func bind(to subject: CurrentValueSubject<Output, Never>) -> AnyCancellable {
    let cancellable = subscribe(subject)
    subject.store(cancellable)
    return cancellable
  }

  @discardableResult
  func bind(to subject: CurrentValueSubject<Output?, Never>) -> AnyCancellable {
    map(Optional.some).bind(to: subject)
  }

  @discardableResult
  func bind(to subject: PassthroughSubject<Output, Never>) -> AnyCancellable {
    let cancellable = subscribe(subject)
    subject.store(cancellable)
    return cancellable
  }

  @discardableResult
  func bind(to subject: PassthroughSubject<Output?, Never>) -> AnyCancellable {
    map(Optional.some).bind(to: subject)
  }

  @discardableResult
  func bind<Target: BindingProvider & AnyObject>(
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
