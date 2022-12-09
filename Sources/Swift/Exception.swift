public func silent(perform: () throws -> Void) {
  do {
    return try perform()
  } catch {
    debugPrint(error)
  }
}

@discardableResult
public func attempt<T>(perform: () throws -> T) rethrows -> T {
  do {
    return try perform()
  } catch {
    debugPrint(error)
    throw error
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public func silent(perform: () async throws -> Void) async {
  do {
    return try await perform()
  } catch {
    debugPrint(error)
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
@discardableResult
public func attempt<T>(perform: () async throws -> T) async rethrows -> T {
  do {
    return try await perform()
  } catch {
    debugPrint(error)
    throw error
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

  @discardableResult
  static func attempt(
    priority: TaskPriority? = nil,
    operation: @escaping () async throws -> Success
  ) -> Self
  where Failure == any Error {
    .init(priority: priority) {
      do {
        return try await operation()
      } catch {
        debugPrint(error)
        throw error
      }
    }
  }
}
