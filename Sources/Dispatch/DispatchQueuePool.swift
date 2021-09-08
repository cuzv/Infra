import Dispatch
import Foundation

// Swift version of YYDispatchQueuePool.
// See https://github.com/ibireme/YYDispatchQueuePool

private let kMaxQueueCount = 32

struct DispatchContext {
  let name: String
  let queues: [DispatchQueue]
  let queueCount: Int
  fileprivate(set) var counter: Int32
}

extension DispatchContext {
  init(name: String, queueCount: Int, qos: DispatchQoS) {
    self.name = name
    self.queues = (0..<queueCount) .map { DispatchQueue(label: name + "\($0)", qos: qos) }
    self.queueCount = queueCount
    self.counter = 0
  }

  private static var appropriateQueueCount: Int {
    var count = ProcessInfo.processInfo.activeProcessorCount
    count = count < 1 ? 1 : count > kMaxQueueCount ? kMaxQueueCount : count
    return count
  }

  fileprivate static let userInteractive: DispatchContext = .init(name: "com.redrainlab.queue.qos.userInteractive", queueCount: appropriateQueueCount, qos: .userInteractive)
  fileprivate static let userInitiated: DispatchContext = .init(name: "com.redrainlab.queue.qos.userInitiated", queueCount: appropriateQueueCount, qos: .userInitiated)
  fileprivate static let utility: DispatchContext = .init(name: "com.redrainlab.queue.qos.utility", queueCount: appropriateQueueCount, qos: .utility)
  fileprivate static let background: DispatchContext = .init(name: "com.redrainlab.queue.qos.background", queueCount: appropriateQueueCount, qos: .background)
  fileprivate static let `default`: DispatchContext = .init(name: "com.redrainlab.queue.qos.default", queueCount: appropriateQueueCount, qos: .default)
}

final class DispatchQueuePool {
  private let lock: NSLock = {
    let lock = NSLock()
    lock.name = "DispatchQueuePool"
    return lock
  }()
  private var context: DispatchContext

  init(context: DispatchContext) {
    self.context = context
  }

  init(name: String, queueCount: Int, qos: DispatchQoS) {
    let count = queueCount < 1 ? 1 : queueCount > kMaxQueueCount ? kMaxQueueCount : queueCount
    self.context = .init(name: name, queueCount: count, qos: qos)
  }

  static let userInteractive: DispatchQueuePool = .init(context: .userInteractive)
  static let userInitiated: DispatchQueuePool = .init(context: .userInitiated)
  static let utility: DispatchQueuePool = .init(context: .utility)
  static let background: DispatchQueuePool = .init(context: .background)
  static let `default`: DispatchQueuePool = .init(context: .default)

  var queue: DispatchQueue {
    lock.lock()
    defer {
      lock.unlock()
    }
    let oldValue = Int(context.counter)
    context.counter += 1
    let queue = context.queues[oldValue % context.queueCount]
    return queue
  }
}

extension DispatchQueue {
  public static func serial(qos: DispatchQoS = .unspecified) -> DispatchQueue {
    let pool: DispatchQueuePool

    switch qos {
    case .userInteractive:
      pool = .userInteractive
    case .userInitiated:
      pool = .userInitiated
    case .utility:
      pool = .utility
    case .background:
      pool = .background
    default:
      pool = .default
    }

    return pool.queue
  }
}
