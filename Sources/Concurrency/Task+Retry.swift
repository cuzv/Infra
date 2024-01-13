import Foundation

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, macCatalyst 15.0, *)
public extension Task where Failure == Error {
  /// Automatically retrying an asynchronous Swift Task
  ///
  /// Copied from https://www.swiftbysundell.com/articles/retrying-an-async-swift-task/
  @discardableResult
  init(
    priority: TaskPriority? = nil,
    maxRetryCount: Int,
    retryDelay: TimeInterval = 1,
    operation: @Sendable @escaping () async throws -> Success
  ) {
    self.init(priority: priority) {
      for _ in 0 ..< maxRetryCount {
        do {
          return try await operation()
        } catch {
          let oneSecond = TimeInterval(1_000_000_000)
          let delay = UInt64(oneSecond * retryDelay)
          try await Task<Never, Never>.sleep(nanoseconds: delay)

          try Task<Never, Never>.checkCancellation()
          continue
        }
      }

      return try await operation()
    }
  }
}
