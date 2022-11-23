#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Publisher {
  public func concat(_ others: Self...) -> AnyPublisher<Output, Failure> {
    var result = append(others.first!).eraseToAnyPublisher()
    if others.count > 1 {
      for p in others[1...] {
        result = result.append(p).eraseToAnyPublisher()
      }
    }
    return result
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension AnyPublisher {
  public static func concat<P: Publisher>(_ others: [P]) -> AnyPublisher<P.Output, P.Failure> {
    precondition(!others.isEmpty)

    switch others.count {
    case 1:
      return others[0].eraseToAnyPublisher()
    case 2:
      return others[0].append(others[1]).eraseToAnyPublisher()
    case 3...:
      var result = others[0].append(others[1]).eraseToAnyPublisher()
      for p in others[2...] {
        result = result.append(p).eraseToAnyPublisher()
      }
      return result
    default:
      fatalError()
    }
  }
}
#endif
