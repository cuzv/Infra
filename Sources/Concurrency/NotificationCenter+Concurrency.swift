import Foundation

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, macCatalyst 15.0, *)
public extension NotificationCenter {
  func notifications(
    for name: Notification.Name,
    object obj: Any? = nil,
    queue: OperationQueue? = nil
  ) -> AsyncStream<Notification> {
    AsyncStream<Notification> { continuation in
      NotificationCenter.default.addObserver(
        forName: name,
        object: obj,
        queue: queue,
        using: { notification in
          continuation.yield(notification)
        }
      )
    }
  }
}
