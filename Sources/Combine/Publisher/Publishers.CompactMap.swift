#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publisher {
  func rejectNils<Wrapped>()
    -> Publishers.CompactMap<Self, Wrapped>
    where Output == Wrapped?
  {
    compactMap { $0 ?? nil }
  }

  func with<Inserted: AnyObject>(
    _ inserted: Inserted
  ) -> Publishers.CompactMap<Self, (Output, Inserted)> {
    compactMap { [weak inserted] value in
      if let inserted {
        return (value, inserted)
      }
      return nil
    }
  }

  func succeeding<Successor: AnyObject>(
    _ successor: Successor
  ) -> Publishers.CompactMap<Self, Successor> {
    compactMap { [weak successor] _ in
      successor
    }
  }

  @inline(__always)
  func compactMap<E>(
    _ type: E.Type
  ) -> Publishers.CompactMap<Self, E> {
    compactMap { $0 as? E }
  }
}
#endif
