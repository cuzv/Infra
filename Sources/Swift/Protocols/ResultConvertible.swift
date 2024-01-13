public protocol ResultConvertible {
  associatedtype Success
  associatedtype Failure: Swift.Error

  var result: Swift.Result<Success, Failure> { get }
}

public extension ResultConvertible {
  var success: Success? {
    if case let .success(value) = result { return value }
    return nil
  }

  var failure: Failure? {
    if case let .failure(value) = result { return value }
    return nil
  }

  var isSuccess: Bool {
    switch result {
    case .success: true
    case .failure: false
    }
  }

  var isFailure: Bool {
    !isSuccess
  }

  func void() -> Swift.Result<Void, Failure> {
    result.map { _ in }
  }
}

extension Swift.Result: ResultConvertible {
  public var result: Swift.Result<Success, Failure> {
    self
  }
}

public extension Swift.Result {
  init(success: Success) {
    self = .success(success)
  }

  init(failure: Failure) {
    self = .failure(failure)
  }

  init(_ success: Success?, failWith failure: @autoclosure () -> Failure) {
    self = success.map(Swift.Result.success) ?? .failure(failure())
  }
}
