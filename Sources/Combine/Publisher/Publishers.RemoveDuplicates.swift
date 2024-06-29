#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
  func removeDuplicates(
    by transform: @escaping (Self.Output) -> some Equatable
  ) -> Publishers.RemoveDuplicates<Self> {
    removeDuplicates { lhs, rhs in
      transform(lhs) == transform(rhs)
    }
  }
}
#endif
