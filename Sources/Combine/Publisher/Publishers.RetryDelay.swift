#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publisher {
  /// Origin from https://gist.github.com/ollieatkinson/c14d60d7a83f7cbbe384d0c4f486a46b
  func retry<S: Scheduler>(
    _ max: Int = Int.max,
    delay: Publishers.RetryDelay<Self, S>.TimingFunction,
    scheduler: S
  ) -> Publishers.RetryDelay<Self, S> {
    .init(upstream: self, max: max, delay: delay, scheduler: scheduler)
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publishers {
  struct RetryDelay<Upstream: Publisher, S: Scheduler>: Publisher {
    public typealias Output = Upstream.Output
    public typealias Failure = Upstream.Failure

    public let upstream: Upstream

    public let retries: Int
    public let max: Int
    public let delay: TimingFunction
    public let scheduler: S

    public init(upstream: Upstream, retries: Int = 0, max: Int, delay: TimingFunction, scheduler: S) {
      self.upstream = upstream
      self.retries = retries
      self.max = max
      self.delay = delay
      self.scheduler = scheduler
    }

    public func receive<Sub: Subscriber>(subscriber: Sub) where Upstream.Failure == Sub.Failure, Upstream.Output == Sub.Input {
      upstream.catch { e -> AnyPublisher<Output, Failure> in
        guard retries < max else { return Fail(error: e).eraseToAnyPublisher() }
        return Fail(error: e)
          .delay(for: .seconds(delay(retries + 1)), scheduler: scheduler)
          .catch { _ in
            RetryDelay(
              upstream: upstream,
              retries: retries + 1,
              max: max,
              delay: delay,
              scheduler: scheduler
            )
          }
          .eraseToAnyPublisher()
      }
      .subscribe(subscriber)
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publishers.RetryDelay {
  typealias TimingFunction = RetryDelayTimingFunction
}

public struct RetryDelayTimingFunction {
  let function: (Int) -> TimeInterval

  public init(_ function: @escaping (Int) -> TimeInterval) {
    self.function = function
  }

  public func callAsFunction(_ n: Int) -> TimeInterval {
    function(n)
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publishers.RetryDelay.TimingFunction {
  static let immediate: Self = .after(seconds: 0)
  static func after(seconds time: TimeInterval) -> Self { .init(time) }
  static func exponential(unit: TimeInterval = 0.5) -> Self {
    .init { n in
      TimeInterval.random(in: unit ... unit * pow(2, TimeInterval(n - 1)))
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Publishers.RetryDelay.TimingFunction: ExpressibleByFloatLiteral {
  public init(_ value: TimeInterval) {
    self.init { _ in value }
  }

  public init(floatLiteral value: TimeInterval) {
    self.init(value)
  }
}
#endif
