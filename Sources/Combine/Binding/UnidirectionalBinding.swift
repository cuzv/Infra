#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

// MARK: - Operator =>

precedencegroup BindingPrecedence {
  associativity: none

  // Binds tighter than assignment but looser than everything else
  higherThan: AssignmentPrecedence
}

infix operator =>: BindingPrecedence

// MARK: - UnidirectionalBinding

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public protocol UnidirectionalBinding: Subscriber, Cancellable {
  @discardableResult
  static func => <P: Publisher>(source: P, subscriber: Self) -> AnyCancellable where Input == P.Output, Failure == P.Failure
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension UnidirectionalBinding {
  @discardableResult
  static func => <P: Publisher>(source: P, subscriber: Self) -> AnyCancellable where Input == P.Output?, Failure == P.Failure {
    source.map(Optional.some) => subscriber
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publisher {
  @discardableResult
  static func => <S: UnidirectionalBinding>(
    source: Self,
    subscriber: S
  ) -> AnyCancellable where Output == S.Input, Failure == S.Failure {
    source => subscriber
  }
}
#endif
