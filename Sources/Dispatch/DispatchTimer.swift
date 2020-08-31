import Foundation

public final class DispatchTimer {
    public var eventHandler: (() -> Void)?

    private let timeInterval: TimeInterval
    private let leeway: DispatchTimeInterval
    private let targetQueue: DispatchQueue?

    public init(timeInterval: TimeInterval, leeway: DispatchTimeInterval = .nanoseconds(0), targetQueue: DispatchQueue? = nil) {
        self.timeInterval = timeInterval
        self.leeway = leeway
        self.targetQueue = targetQueue
    }

    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: targetQueue)
        timer.schedule(deadline: .now() + timeInterval, repeating: timeInterval, leeway: leeway)
        timer.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return timer
    }()

    private enum State {
        case suspended
        case resumed
    }

    private var state: State = .suspended

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        // If the timer is suspended, calling cancel without resuming triggers a crash.
        resume()
        eventHandler = nil
    }

    public func resume() {
        if state == .resumed { return }
        state = .resumed
        timer.resume()
    }

    public func suspend() {
        if state == .suspended { return }
        state = .suspended
        timer.suspend()
    }
}
