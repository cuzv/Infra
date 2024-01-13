#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publisher {
  func filter(
    _ isIncluded: Output...
  ) -> Publishers.Filter<Self> where Output: Equatable {
    filter { isIncluded.contains($0) }
  }

  func filter(
    _ isIncluded: [Output]
  ) -> Publishers.Filter<Self> where Output: Equatable {
    filter { isIncluded.contains($0) }
  }
}
#endif
