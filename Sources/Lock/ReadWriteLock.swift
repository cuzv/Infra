import Darwin

public final class ReadWriteLock: ReadWriteLocking {
  public init() {}

  private var rwlock: pthread_rwlock_t = {
    var rwlock = pthread_rwlock_t()
    pthread_rwlock_init(&rwlock, nil)
    return rwlock
  }()

  public func writeLock() {
    pthread_rwlock_wrlock(&rwlock)
  }

  public func readLock() {
    pthread_rwlock_rdlock(&rwlock)
  }

  public func unlock() {
    pthread_rwlock_unlock(&rwlock)
  }
}
