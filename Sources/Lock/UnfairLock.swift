import Darwin

@available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, macCatalyst 13.0, *)
public final class UnfairLock: Locking {
  private var unfairLock = os_unfair_lock_s()

  public init() {}

  public func lock() {
    os_unfair_lock_lock(&unfairLock)
  }

  public func unlock() {

    os_unfair_lock_unlock(&unfairLock)
  }

  public func `try`() -> Bool {
    return os_unfair_lock_trylock(&unfairLock)
  }
}

@available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, macCatalyst 13.0, *)
public typealias SpinLock = UnfairLock
