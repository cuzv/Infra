#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

// MARK: - Factory

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.2, macCatalyst 13.0, *)
public extension AnyPublisher {
  static func single(
    _ factory: @escaping (@escaping (Swift.Result<Output, Failure>) -> Void) -> () -> Void
  ) -> AnyPublisher<Output, Failure> {
    let holder = CancellationHolder()
    return Future { [weak holder] promise in
      holder?.onCancel = factory { result in
        promise(result)
      }
    }
    .handleEvents(receiveCancel: holder.cancel)
    .eraseToAnyPublisher()
  }

  static func multiple(
    _ factory: @escaping (@escaping (Swift.Result<Output, Failure>) -> Void) -> () -> Void
  ) -> AnyPublisher<Output, Failure> {
    let holder = CancellationHolder()
    let subject = PassthroughSubject<Output, Failure>()

    holder.onCancel = factory { [weak subject] result in
      switch result {
      case let .success(output):
        subject?.send(output)
      case let .failure(error):
        subject?.send(completion: .failure(error))
      }
    }

    return subject
      .handleEvents(receiveCancel: holder.cancel)
      .eraseToAnyPublisher()
  }
}

// MARK: - CancellationHolder

final class CancellationHolder: Cancellable {
  var onCancel: (() -> Void)?

  func cancel() {
    onCancel?()
  }
}
#endif
