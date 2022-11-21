import Foundation

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, macCatalyst 15.0, *)
extension Task where Failure == Error {
  /// Delaying an asynchronous Swift Task
  ///
  /// Copied from https://www.swiftbysundell.com/articles/delaying-an-async-swift-task/
  @discardableResult
  public init(
    priority: TaskPriority? = nil,
    delay interval: TimeInterval,
    operation: @escaping @Sendable () async throws -> Success
  ) {
    self.init(priority: priority) {
      let oneSecond = TimeInterval(1_000_000_000)
      let delay = UInt64(interval * oneSecond)
      try await Task<Never, Never>.sleep(nanoseconds: delay)

      try Task<Never, Never>.checkCancellation()
      return try await operation()
    }
  }
}
