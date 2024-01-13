import OSLog

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, macCatalyst 14.0, *)
let logger = Logger(subsystem: "com.redrainlab.app.infra", category: "Exception")

private func log(_ error: Error) {
  if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, macCatalyst 14.0, *) {
    logger.debug("\(error)")
  } else {
    debugPrint(error)
  }
}

public func silent(perform: () throws -> Void) {
  do {
    return try perform()
  } catch {
    log(error)
  }
}

@discardableResult
public func attempt<T>(perform: () throws -> T) rethrows -> T {
  do {
    return try perform()
  } catch {
    log(error)
    throw error
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public func silent(perform: () async throws -> Void) async {
  do {
    return try await perform()
  } catch {
    log(error)
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
@discardableResult
public func attempt<T>(perform: () async throws -> T) async rethrows -> T {
  do {
    return try await perform()
  } catch {
    log(error)
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
    where Success == Void, Failure == Never
  {
    .init(priority: priority) {
      do {
        try await operation()
      } catch {
        log(error)
      }
    }
  }

  @discardableResult
  static func attempt(
    priority: TaskPriority? = nil,
    operation: @escaping () async throws -> Success
  ) -> Self
    where Failure == any Error
  {
    .init(priority: priority) {
      do {
        return try await operation()
      } catch {
        log(error)
        throw error
      }
    }
  }
}
