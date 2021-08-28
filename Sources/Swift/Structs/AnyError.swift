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
		return AnyError(error)
	}
}

extension AnyError: CustomStringConvertible {
	public var description: String {
		return String(describing: error)
	}
}

extension AnyError: LocalizedError {
	public var errorDescription: String? {
		return error.localizedDescription
	}

	public var failureReason: String? {
		return (error as? LocalizedError)?.failureReason
	}

	public var helpAnchor: String? {
		return (error as? LocalizedError)?.helpAnchor
	}

	public var recoverySuggestion: String? {
		return (error as? LocalizedError)?.recoverySuggestion
	}
}

extension Swift.Result where Failure == AnyError {
    public init(_ f: @autoclosure () throws -> Success) {
        self.init(attempt: f)
    }

    public init(attempt body: () throws -> Success) {
        do {
            self = .success(try body())
        } catch {
            self = .failure(AnyError(error))
        }
    }
}
