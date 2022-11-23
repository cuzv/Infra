// Extracted from https://www.swiftbysundell.com/articles/calling-async-functions-within-a-combine-pipeline/

import Combine

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publisher {
  func asyncMap<T>(
    withPriority priority: TaskPriority? = nil,
    _ transform: @escaping (Output) async -> T
  ) -> Publishers.FlatMap<Future<T, Never>, Self> {
    flatMap { value in
      Future { promise in
        Task(priority: priority) {
          let output = await transform(value)
          promise(.success(output))
        }
      }
    }
  }

  func asyncMap<T>(
    withPriority priority: TaskPriority? = nil,
    _ transform: @escaping (Output) async throws -> T
  ) -> Publishers.FlatMap<Future<T, Error>, Self> {
    flatMap { value in
      Future { promise in
        Task(priority: priority) {
          do {
            let output = try await transform(value)
            promise(.success(output))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
  }

  func asyncSink(
    withPriority priority: TaskPriority? = nil,
    receiveValue: @escaping ((Output) async -> Void)
  ) -> AnyCancellable where Failure == Never {
    sink { output in
      Task(priority: priority) {
        await receiveValue(output)
      }
    }
  }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, macCatalyst 14.0, *)
public extension Publisher {
  func asyncMap<T>(
    withPriority priority: TaskPriority? = nil,
    _ transform: @escaping (Output) async throws -> T
  ) -> Publishers.FlatMap<Future<T, Error>, Publishers.SetFailureType<Self, Error>> {
    flatMap { value in
      Future { promise in
        Task(priority: priority) {
          do {
            let output = try await transform(value)
            promise(.success(output))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
  }
}
