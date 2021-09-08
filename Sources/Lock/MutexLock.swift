import Foundation

public final class MutexLock: Locking {
  public init() {}

  private var mutex: pthread_mutex_t = {
    var mutex = pthread_mutex_t()
    pthread_mutex_init(&mutex, nil)
    return mutex
  }()

  public func lock() {
    pthread_mutex_lock(&mutex)
  }

  public func unlock() {
    pthread_mutex_unlock(&mutex)
  }
}
