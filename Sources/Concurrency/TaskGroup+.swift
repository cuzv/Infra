@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension TaskGroup {
  func values() async -> [ChildTaskResult] {
    var values = [ChildTaskResult]()

    for await element in self {
      values.append(element)
    }

    return values
  }
}
