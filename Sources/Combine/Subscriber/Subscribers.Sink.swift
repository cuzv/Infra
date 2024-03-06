#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publisher {
  func sink(_ prefix: String? = nil) -> AnyCancellable {
    if let prefix {
      print(prefix).sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    } else {
      sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
  }
}
#endif
