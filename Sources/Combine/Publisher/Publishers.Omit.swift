#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
  func omit(
    _ isExcluded: @escaping (Output) -> Bool
  ) -> Publishers.Filter<Self> {
    filter({ !isExcluded($0) })
  }

  func tryOmit(
    _ isExcluded: @escaping (Output) throws -> Bool
  ) -> Publishers.TryFilter<Self> {
    tryFilter({ try !isExcluded($0) })
  }

  func omit(
    _ isExcluded: Output...
  ) -> Publishers.Filter<Self> where Output: Equatable {
    filter({ !isExcluded.contains($0) })
  }

  func omit(
    _ isExcludedA: @escaping (Output) -> Bool,
    _ isExcludedB: @escaping (Output) -> Bool
  ) -> Publishers.Filter<Self> {
    filter({ !isExcludedA($0) })
      .filter({ !isExcludedB($0) })
  }

  func omit(
    _ isExcludedA: @escaping (Output) -> Bool,
    _ isExcludedB: @escaping (Output) -> Bool,
    _ isExcludedC: @escaping (Output) -> Bool
  ) -> Publishers.Filter<Self> {
    filter({ !isExcludedA($0) })
      .filter({ !isExcludedB($0) })
      .filter({ !isExcludedC($0) })
  }
}
#endif
