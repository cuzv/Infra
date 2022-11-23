#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Publisher {
  public func tryMap<A, B>(
    _ transformA: @escaping (Output) throws -> A,
    _ transformB: @escaping (Output) throws -> B
  ) -> Publishers.TryMap<Self, (A, B)> {
    tryMap { output in
      (try transformA(output), try transformB(output))
    }
  }

  public func tryMap<A, B, C>(
    _ transformA: @escaping (Output) throws -> A,
    _ transformB: @escaping (Output) throws -> B,
    _ transformC: @escaping (Output) throws -> C
  ) -> Publishers.TryMap<Self, (A, B, C)> {
    tryMap { output in
      (try transformA(output), try transformB(output), try transformC(output))
    }
  }

  public func tryMutate(
    _ mutation: @escaping (inout Output) throws -> Void
  ) -> Publishers.TryMap<Self, Output> {
    tryMap { output in
      var result = output
      try mutation(&result)
      return result
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Publisher where Output: Collection {
  public func tryMapMany<Result>(
    _ transform: @escaping (Output.Element) throws -> Result
  ) -> Publishers.TryMap<Self, [Result]> {
    tryMap { output in
      try output.map(transform)
    }
  }

  public func tryMutateMany(
    _ mutation: @escaping (inout Output.Element) throws -> Void
  ) -> Publishers.TryMap<Self, [Output.Element]> {
    tryMapMany { output in
      var result = output
      try mutation(&result)
      return result
    }
  }
}
#endif
