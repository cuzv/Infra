#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Publisher {
  public func drop(
    _ isExcluded: Output...
  ) -> Publishers.DropWhile<Self> where Output: Equatable {
    drop { isExcluded.contains($0) }
  }

  public func drop(
    _ isExcluded: [Output]
  ) -> Publishers.DropWhile<Self> where Output: Equatable {
    drop { isExcluded.contains($0) }
  }
}
#endif
