import Foundation

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, macCatalyst 15.0, *)
public actor TimeoutTask<Success> {
  private let nanoseconds: UInt64
  private let operation: @Sendable () async throws -> Success

  private var continuation: CheckedContinuation<Success, Error>?

  public var value: Success {
    get async throws {
      try await withCheckedThrowingContinuation { continuation in
        self.continuation = continuation

        Task {
          try await Task.sleep(nanoseconds: nanoseconds)
          if let continuation = self.continuation {
            self.continuation = nil
            continuation.resume(throwing: TimeoutError())
          }
        }

        Task {
          let result = try await operation()
          if let continuation = self.continuation {
            self.continuation = nil
            continuation.resume(returning: result)
          }
        }
      }
    }
  }

  public func cancel() {
    if let ctn = continuation {
      continuation = nil
      ctn.resume(throwing: CancellationError())
    }
  }

  public init(
    seconds: TimeInterval,
    operation: @escaping @Sendable () async throws -> Success
  ) {
    self.nanoseconds = UInt64(seconds * 1_000_000_000)
    self.operation = operation
  }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, macCatalyst 15.0, *)
extension TimeoutTask {
  public struct TimeoutError: LocalizedError {
    public var errorDescription: String? {
      "The operation timed out."
    }
  }
}
