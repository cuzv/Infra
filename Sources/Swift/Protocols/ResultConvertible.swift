public protocol ResultConvertible {
  associatedtype Success
  associatedtype Failure: Swift.Error

  var result: Swift.Result<Success, Failure> { get }
}

extension ResultConvertible {
  public var success: Success? {
    if case let .success(value) = result { return value }
    return nil
  }

  public var failure: Failure? {
    if case let .failure(value) = result { return value }
    return nil
  }

  public var isSuccess: Bool {
    switch result {
    case .success: return true
    case .failure: return false
    }
  }

  public var isFailure: Bool {
    !isSuccess
  }

  public func void() -> Swift.Result<Void, Failure> {
    result.map { _ in }
  }
}

extension Swift.Result: ResultConvertible {
  public var result: Swift.Result<Success, Failure> {
    self
  }
}

extension Swift.Result {
  public init(success: Success) {
    self = .success(success)
  }

  public init(failure: Failure) {
    self = .failure(failure)
  }

  public init(_ success: Success?, failWith failure: @autoclosure () -> Failure) {
    self = success.map(Swift.Result.success) ?? .failure(failure())
  }
}
