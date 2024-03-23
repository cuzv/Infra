#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publishers {
  struct CombineLatest5<A, B, C, D, E>: Publisher where A: Publisher, B: Publisher, C: Publisher, D: Publisher, E: Publisher, A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure, D.Failure == E.Failure {
    public typealias Output = (A.Output, B.Output, C.Output, D.Output, E.Output)
    public typealias Failure = A.Failure

    let a: A
    let b: B
    let c: C
    let d: D
    let e: E

    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) {
      self.a = a
      self.b = b
      self.c = c
      self.d = d
      self.e = e
    }

    public func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
      CombineLatest4(a, b, c, d)
        .combineLatest(e) { values, e in
          let (a, b, c, d) = values
          return (a, b, c, d, e)
        }
        .subscribe(subscriber)
    }
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publishers {
  struct CombineLatest6<A, B, C, D, E, F>: Publisher where A: Publisher, B: Publisher, C: Publisher, D: Publisher, E: Publisher, F: Publisher, A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure, D.Failure == E.Failure, E.Failure == F.Failure {
    public typealias Output = (A.Output, B.Output, C.Output, D.Output, E.Output, F.Output)
    public typealias Failure = A.Failure

    let a: A
    let b: B
    let c: C
    let d: D
    let e: E
    let f: F

    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) {
      self.a = a
      self.b = b
      self.c = c
      self.d = d
      self.e = e
      self.f = f
    }

    public func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
      CombineLatest4(a, b, c, d)
        .combineLatest(e, f) { values, e, f in
          let (a, b, c, d) = values
          return (a, b, c, d, e, f)
        }
        .subscribe(subscriber)
    }
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publishers {
  struct CombineLatest7<A, B, C, D, E, F, G>: Publisher where A: Publisher, B: Publisher, C: Publisher, D: Publisher, E: Publisher, F: Publisher, G: Publisher, A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure, D.Failure == E.Failure, E.Failure == F.Failure, F.Failure == G.Failure {
    public typealias Output = (A.Output, B.Output, C.Output, D.Output, E.Output, F.Output, G.Output)
    public typealias Failure = A.Failure

    let a: A
    let b: B
    let c: C
    let d: D
    let e: E
    let f: F
    let g: G

    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) {
      self.a = a
      self.b = b
      self.c = c
      self.d = d
      self.e = e
      self.f = f
      self.g = g
    }

    public func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
      CombineLatest5(a, b, c, d, e)
        .combineLatest(f, g) { values, f, g in
          let (a, b, c, d, e) = values
          return (a, b, c, d, e, f, g)
        }
        .subscribe(subscriber)
    }
  }
}
#endif
