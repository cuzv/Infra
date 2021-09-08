import Dispatch

/// See http://khanlou.com/2016/04/the-GCD-handbook/
public final class AsyncTaskSerialQueue {
  private let serialQueue: DispatchQueue

  public init(
    label: String,
    qos: DispatchQoS = .unspecified,
    autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency = .inherit,
    target: DispatchQueue? = nil
  ) {
    serialQueue = .init(
      label: label,
      qos: qos,
      attributes: [],
      autoreleaseFrequency: autoreleaseFrequency,
      target: target
    )
  }

  public func enqueue(
    asyncTask block: @escaping (@escaping () -> Void) -> Void
  ) {
    serialQueue.async(execute: block)
  }
}
