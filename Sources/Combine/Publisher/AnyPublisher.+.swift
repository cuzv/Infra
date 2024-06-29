#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension AnyPublisher {
  init(result: Result<Output, Failure>) {
    switch result {
    case let .success(success):
      self = Just(success)
        .setFailureType(to: Failure.self)
        .eraseToAnyPublisher()
    case let .failure(failure):
      self = Fail<Output, Failure>(
        error: failure
      ).eraseToAnyPublisher()
    }
  }

  static func attempt(
    body: () throws -> Output
  ) -> AnyPublisher<Output, Failure>
    where Failure == AnyError
  {
    .init(result: .init(attempt: body))
  }
}
#endif
