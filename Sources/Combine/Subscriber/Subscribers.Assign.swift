#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Publisher where Failure == Never {
  func assign(
    to subjects: CurrentValueSubject<Output, Failure>...
  ) -> AnyCancellable {
    sink { value in
      for subject in subjects {
        subject.send(value)
      }
    }
  }

  func assignSafely(
    to subjects: CurrentValueSubject<Output, Failure>...
  ) -> AnyCancellable {
    receive(on: DispatchQueue.main).sink { value in
      for subject in subjects {
        subject.send(value)
      }
    }
  }

  func assign<S>(
    to subjects: CurrentValueSubject<Output, Failure>...,
    on scheduler: S,
    options: S.SchedulerOptions? = nil
  ) -> AnyCancellable where S: Scheduler {
    receive(on: scheduler, options: options).sink { value in
      for subject in subjects {
        subject.send(value)
      }
    }
  }

  func assign(
    to subjects: CurrentValueSubject<Output?, Failure>...
  ) -> AnyCancellable {
    sink { value in
      for subject in subjects {
        subject.send(value)
      }
    }
  }

  func assignSafely(
    to subjects: CurrentValueSubject<Output?, Failure>...
  ) -> AnyCancellable {
    receive(on: DispatchQueue.main).sink { value in
      for subject in subjects {
        subject.send(value)
      }
    }
  }

  func assign<S>(
    to subjects: CurrentValueSubject<Output?, Failure>...,
    on scheduler: S,
    options: S.SchedulerOptions? = nil
  ) -> AnyCancellable where S: Scheduler {
    receive(on: scheduler, options: options).sink { value in
      for subject in subjects {
        subject.send(value)
      }
    }
  }

  func assign<Root>(
    to keyPath: ReferenceWritableKeyPath<Root, Output?>,
    on object: Root
  ) -> AnyCancellable {
    map(Optional.init).assign(to: keyPath, on: object)
  }

  func assignSafely<Root>(
    to keyPath: ReferenceWritableKeyPath<Root, Output?>,
    on object: Root
  ) -> AnyCancellable {
    assign(to: keyPath, on: object, on: DispatchQueue.main)
  }

  func assign<Root, S>(
    to keyPath: ReferenceWritableKeyPath<Root, Output?>,
    on object: Root,
    on scheduler: S,
    options: S.SchedulerOptions? = nil
  ) -> AnyCancellable where S: Scheduler {
    receive(on: scheduler, options: options)
      .assign(to: keyPath, on: object)
  }

  func assignWeak<Root>(
    to keyPath: ReferenceWritableKeyPath<Root, Output>,
    on object: Root?
  ) -> AnyCancellable where Root: AnyObject {
    sink { [weak object] value in
      object?[keyPath: keyPath] = value
    }
  }

  func assignWeakSafely<Root>(
    to keyPath: ReferenceWritableKeyPath<Root, Output>,
    on object: Root?
  ) -> AnyCancellable where Root: AnyObject {
    assignWeak(to: keyPath, on: object, on: DispatchQueue.main)
  }

  func assignWeak<Root, S>(
    to keyPath: ReferenceWritableKeyPath<Root, Output>,
    on object: Root?,
    on scheduler: S,
    options: S.SchedulerOptions? = nil
  ) -> AnyCancellable where Root: AnyObject, S: Scheduler {
    receive(on: scheduler, options: options)
      .assignWeak(to: keyPath, on: object)
  }

  func assignWeak<Root>(
    to keyPath: ReferenceWritableKeyPath<Root, Output?>,
    on object: Root?
  ) -> AnyCancellable where Root: AnyObject {
    map(Optional.init).assignWeak(to: keyPath, on: object)
  }

  func assignWeakSafely<Root>(
    to keyPath: ReferenceWritableKeyPath<Root, Output?>,
    on object: Root?
  ) -> AnyCancellable where Root: AnyObject {
    assignWeak(to: keyPath, on: object, on: DispatchQueue.main)
  }

  func assignWeak<Root, S>(
    to keyPath: ReferenceWritableKeyPath<Root, Output?>,
    on object: Root?,
    on scheduler: S,
    options: S.SchedulerOptions? = nil
  ) -> AnyCancellable where Root: AnyObject, S: Scheduler {
    receive(on: scheduler, options: options)
      .assignWeak(to: keyPath, on: object)
  }
}
#endif
