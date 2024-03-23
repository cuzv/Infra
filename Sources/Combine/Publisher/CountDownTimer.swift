#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public struct CountDownTimer: Publisher {
  public typealias Output = TimeRemaining
  public typealias Failure = Never

  public let duration: TimeInterval

  public init(duration: TimeInterval) {
    self.duration = duration
  }

  public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Output == S.Input {
    let subscription = CountDownSubscription(duration: duration, subscriber: subscriber)
    subscriber.receive(subscription: subscription)
  }

  public struct TimeRemaining: CustomStringConvertible, Equatable {
    public let min: Int
    public let seconds: Int
    public let totalSeconds: Int

    public init(min: Int, seconds: Int, totalSeconds: Int) {
      self.min = min
      self.seconds = seconds
      self.totalSeconds = totalSeconds
    }

    public static let zero = TimeRemaining(min: 0, seconds: 0, totalSeconds: 0)

    public var description: String {
      if min > 0 {
        String(format: "%02d:%02d", min, seconds)
      } else {
        String(format: "%02d", seconds)
      }
    }

    public var isZero: Bool {
      self == .zero
    }
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
private extension CountDownTimer {
  final class CountDownSubscription<S: Subscriber>: Subscription where S.Input == Output, S.Failure == Failure {
    private var duration: Int
    private var subscriber: S?
    private var timer: Timer?

    deinit {
      Log.out("♻️")
    }

    init(duration: TimeInterval, subscriber: S) {
      self.duration = Int(duration)
      self.subscriber = subscriber
    }

    func request(_ demand: Subscribers.Demand) {
      timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
        guard let self else { return }

        let components = durationToTimeComponents(duration)
        let timeRemaining = TimeRemaining(min: components.min, seconds: components.seconds, totalSeconds: duration)
        _ = subscriber?.receive(timeRemaining)

        if duration == 0 {
          subscriber?.receive(completion: .finished)
        }

        duration -= 1
      })
      timer?.fire()
    }

    func cancel() {
      timer?.invalidate()
    }

    func durationToTimeComponents(_ duration: Int) -> (min: Int, seconds: Int) {
      (min: duration / 60, seconds: duration % 60)
    }
  }
}
#endif
