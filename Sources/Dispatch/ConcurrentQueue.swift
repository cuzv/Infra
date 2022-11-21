import Foundation
import Dispatch

/// See http://khanlou.com/2016/04/the-GCD-handbook/
public final class ConcurrentQueue {
  private let gatekeeperQueue: DispatchQueue
  private let concurrentQueue: DispatchQueue
  private let semaphore: DispatchSemaphore

  public init(
    label: String,
    qos: DispatchQoS = .unspecified,
    autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency = .inherit,
    target: DispatchQueue? = nil,
    maxConcurrentCount count: Int = .max
  ) {
    gatekeeperQueue = .init(label: "Gatekeeper4\(label)", qos: qos)
    concurrentQueue = .init(
      label: label, qos: qos, attributes: [.concurrent],
      autoreleaseFrequency: autoreleaseFrequency, target: target
    )
    semaphore = .init(
      value: count < 1 ? 1 : (
        count > ProcessInfo.processInfo.activeProcessorCount ?
          ProcessInfo.processInfo.activeProcessorCount :
          count
      )
    )
  }

  public func add(syncTask: @escaping () -> Void) {
    gatekeeperQueue.async {
      self.semaphore.wait()
      self.concurrentQueue.async {
        autoreleasepool {
          syncTask()
        }
        self.semaphore.signal()
      }
    }
  }

  public func add(asyncTask: @escaping (@escaping () -> Void) -> Void) {
    gatekeeperQueue.async {
      self.semaphore.wait()
      self.concurrentQueue.async {
        autoreleasepool {
          asyncTask {
            self.semaphore.signal()
          }
        }
      }
    }
  }
}
