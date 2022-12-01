public func silent(perform: () throws -> Void) {
  do {
    try perform()
  } catch {
    debugPrint(error)
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public func silent(perform: () async throws -> Void) async {
  do {
    try await perform()
  } catch {
    debugPrint(error)
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Task {
  @discardableResult
  static func silent(
    priority: TaskPriority? = nil,
    operation: @escaping () async throws -> Void
  ) -> Self
  where Success == Void, Failure == Never {
    .init(priority: priority) {
      do {
        try await operation()
      } catch {
        debugPrint(error)
      }
    }
  }
}
