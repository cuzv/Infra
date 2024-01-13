/// Lock is an abstract concept for threads synchronization. The main idea is to protect access to a given region of code at a time. Different kinds of locks exist:
///
/// See: http://www.vadimbulavin.com/atomic-properties/
///
/// - Semaphore — allows up to N threads to access a given region of code at a time.
/// - Mutex — ensures that only one thread is active in a given region of code at a time. You can think of it as a semaphore with a maximum count of 1.
/// - Spinlock — causes a thread trying to acquire a lock to wait in a loop while checking if the lock is available. It is efficient if waiting is rare, but wasteful if waiting is common.
/// - Read-write lock — provides concurrent access for read-only operations, but exclusive access for write operations. Efficient when reading is common and writing is rare.
/// - Recursive lock — a mutex that can be acquired by the same thread many times.
public protocol Locking {
  func lock()
  func unlock()
}

/// Copied from RxSwift.
public extension Locking {
  @inline(__always)
  func performLocked(_ action: () -> Void) {
    lock()
    defer { unlock() }
    action()
  }

  @inline(__always)
  func calculateLocked<T>(_ action: () -> T) -> T {
    lock()
    defer { unlock() }
    return action()
  }

  @inline(__always)
  func calculateLockedOrFail<T>(_ action: () throws -> T) throws -> T {
    lock()
    defer { unlock() }
    let result = try action()
    return result
  }
}

import class Foundation.NSLock
extension NSLock: Locking {}

import class Foundation.NSRecursiveLock
extension NSRecursiveLock: Locking {}

// MARK: -

public protocol ReadWriteLocking {
  func writeLock()
  func readLock()
  func unlock()
}

public extension ReadWriteLocking {
  @inline(__always)
  func performLockedWrite(_ action: () -> Void) {
    writeLock()
    defer { unlock() }
    action()
  }

  @inline(__always)
  func calculateLockedRead<T>(_ action: () -> T) -> T {
    readLock()
    defer { unlock() }
    return action()
  }

  @inline(__always)
  func calculateLockedReadOrFail<T>(_ action: () throws -> T) throws -> T {
    readLock()
    defer { unlock() }
    let result = try action()
    return result
  }
}
