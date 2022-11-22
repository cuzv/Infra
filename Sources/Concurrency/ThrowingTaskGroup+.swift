@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension ThrowingTaskGroup {
  func values() async throws -> [ChildTaskResult] {
    var values = [ChildTaskResult]()

    for try await element in self {
      values.append(element)
    }

    return values
  }
}
