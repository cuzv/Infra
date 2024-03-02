#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publisher {
  func eraseError() -> AnyPublisher<Output, AnyError> {
    mapError(AnyError.init(_:))
      .eraseToAnyPublisher()
  }
}
#endif
