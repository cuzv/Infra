#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publishers {
  static func CombineLatest5<A, B, C, D, E>(
    _ a: A,
    _ b: B,
    _ c: C,
    _ d: D,
    _ e: E
  ) -> AnyPublisher<(A.Output, B.Output, C.Output, D.Output, E.Output), A.Failure>
    where
    A: Publisher, B: Publisher, C: Publisher, D: Publisher, E: Publisher,
    A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure, D.Failure == E.Failure
  {
    CombineLatest4(
      a,
      b,
      c,
      d
    )
    .combineLatest(e) {
      ($0.0, $0.1, $0.2, $0.3, $1)
    }
    .eraseToAnyPublisher()
  }

  static func CombineLatest6<A, B, C, D, E, F>(
    _ a: A,
    _ b: B,
    _ c: C,
    _ d: D,
    _ e: E,
    _ f: F
  ) -> AnyPublisher<(A.Output, B.Output, C.Output, D.Output, E.Output, F.Output), A.Failure>
    where
    A: Publisher, B: Publisher, C: Publisher, D: Publisher, E: Publisher, F: Publisher,
    A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure, D.Failure == E.Failure, E.Failure == F.Failure
  {
    CombineLatest5(
      a,
      b,
      c,
      d,
      e
    )
    .combineLatest(f) {
      ($0.0, $0.1, $0.2, $0.3, $0.4, $1)
    }
    .eraseToAnyPublisher()
  }

  static func CombineLatest7<A, B, C, D, E, F, G>(
    _ a: A,
    _ b: B,
    _ c: C,
    _ d: D,
    _ e: E,
    _ f: F,
    _ g: G
  ) -> AnyPublisher<(A.Output, B.Output, C.Output, D.Output, E.Output, F.Output, G.Output), A.Failure>
    where
    A: Publisher, B: Publisher, C: Publisher, D: Publisher, E: Publisher, F: Publisher, G: Publisher,
    A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure, D.Failure == E.Failure, E.Failure == F.Failure, F.Failure == G.Failure
  {
    CombineLatest6(
      a,
      b,
      c,
      d,
      e,
      f
    )
    .combineLatest(g) {
      ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $1)
    }
    .eraseToAnyPublisher()
  }
}
#endif
