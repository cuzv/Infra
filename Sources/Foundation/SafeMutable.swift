import Dispatch
import Foundation

@propertyWrapper
public class SafeMutable<Value> {
  private var value: Value
  private let queue: DispatchQueue

  public init(value: Value, queue: DispatchQueue = .init(label: "SafeMutable")) {
    self.value = value
    self.queue = queue
  }

  public var wrappedValue: Value {
    get {
      queue.sync {
        value
      }
    }
    set {
      queue.async {
        self.value = newValue
      }
    }
  }

  public func mutate(_ block: @escaping (inout Value) -> Void) {
    queue.async {
      block(&self.value)
    }
  }
}

public class SafeMutableDictionary<Key: Hashable, Value>: CustomDebugStringConvertible {
  private var dict = [Key: Value]()
  private let queue: DispatchQueue

  public init(queue: DispatchQueue = .init(label: "SafeMutableDictionary.\(UUID().uuidString)", attributes: .concurrent)) {
    self.queue = queue
  }

  public subscript(key: Key) -> Value? {
    get {
      queue.sync {
        dict[key]
      }
    }
    set {
      queue.async(flags: .barrier) { [weak self] in self?.dict[key] = newValue }
    }
  }

  public var count: Int {
    queue.sync {
      dict.count
    }
  }

  public var debugDescription: String {
    dict.debugDescription
  }
}

public class SafeMutableArray<Element> {
  private var array: [Element] = []
  private let queue: DispatchQueue

  public init(queue: DispatchQueue = .init(label: "SafeMutableArray.\(UUID().uuidString)", attributes: .concurrent)) {
    self.queue = queue
  }

  public subscript(index: Int) -> Element? {
    get {
      queue.sync {
        array.indices ~= index ? array[index] : nil
      }
    }
    set {
      queue.async(flags: .barrier) {
        if let newValue, self.array.indices ~= index {
          self.array[index] = newValue
        }
      }
    }
  }

  public var count: Int {
    queue.sync {
      array.count
    }
  }

  public func reserveCapacity(_ count: Int) {
    queue.async(flags: .barrier) {
      self.array.reserveCapacity(count)
    }
  }

  public func append(_ element: Element) {
    queue.async(flags: .barrier) {
      self.array += [element]
    }
  }

  public func removeAll() {
    queue.async(flags: .barrier) {
      self.array = []
    }
  }
}
