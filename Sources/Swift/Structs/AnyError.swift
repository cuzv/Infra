import Foundation

/// A type-erased error which wraps an arbitrary error instance. This should be
/// useful for generic contexts.
public struct AnyError: Swift.Error {
  /// The underlying error.
  public let error: Swift.Error

  public init(_ error: Swift.Error) {
    if let anyError = error as? AnyError {
      self = anyError
    } else {
      self.error = error
    }
  }
}

public protocol ErrorConvertible: Swift.Error {
  static func error(from error: Swift.Error) -> Self
}

extension AnyError: ErrorConvertible {
  public static func error(from error: Error) -> AnyError {
    AnyError(error)
  }
}

extension AnyError: CustomStringConvertible {
  public var description: String {
    String(describing: error)
  }
}

extension AnyError: LocalizedError {
  public var errorDescription: String? {
    error.localizedDescription
  }

  public var failureReason: String? {
    (error as? LocalizedError)?.failureReason
  }

  public var helpAnchor: String? {
    (error as? LocalizedError)?.helpAnchor
  }

  public var recoverySuggestion: String? {
    (error as? LocalizedError)?.recoverySuggestion
  }
}

public extension Swift.Result where Failure == AnyError {
  init(_ f: @autoclosure () throws -> Success) {
    self.init(attempt: f)
  }

  init(attempt body: () throws -> Success) {
    do {
      self = try .success(body())
    } catch {
      self = .failure(AnyError(error))
    }
  }

  @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
  init(attempt body: () async throws -> Success) async {
    do {
      self = try await .success(body())
    } catch {
      self = .failure(AnyError(error))
    }
  }
}
