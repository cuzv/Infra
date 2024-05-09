#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

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
