#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publisher {
  func sink() -> AnyCancellable {
    sink { _ in
    } receiveValue: { _ in
    }
  }
}
#endif
