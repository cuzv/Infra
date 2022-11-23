#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension Publisher where Failure == Never {
  public func assign(
    to subjects: CurrentValueSubject<Output, Failure>...
  ) -> AnyCancellable {
    sink { value in
      subjects.forEach {
        $0.send(value)
      }
    }
  }

  public func assign(
    to subjects: CurrentValueSubject<Output?, Failure>...
  ) -> AnyCancellable {
    sink { value in
      subjects.forEach {
        $0.send(value)
      }
    }
  }

  public func assign<Root>(
    to keyPath: ReferenceWritableKeyPath<Root, Output?>,
    on object: Root
  ) -> AnyCancellable {
    map(Optional.init).assign(to: keyPath, on: object)
  }

  public func assignWeak<Root>(
    to keyPath: ReferenceWritableKeyPath<Root, Output>,
    on object: Root?
  ) -> AnyCancellable where Root: AnyObject {
    sink { [weak object] value in
      object?[keyPath: keyPath] = value
    }
  }

  public func assignWeak<Root>(
    to keyPath: ReferenceWritableKeyPath<Root, Output?>,
    on object: Root?
  ) -> AnyCancellable where Root: AnyObject {
    map(Optional.init).assignWeak(to: keyPath, on: object)
  }
}
#endif
