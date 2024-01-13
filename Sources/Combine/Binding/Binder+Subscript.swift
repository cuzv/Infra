#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Combine where Base: AnyObject & BindingProvider {
  typealias Binder<Value> = Subscribers.Binder<Base, Value>
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Combine where Base: AnyObject & BindingProvider {
  subscript(_ action: @escaping (Base) -> () -> Void) -> Binder<Void> {
    .init(target: base) { base, _ in
      action(base)()
    }
  }

  subscript<Value>(_ action: @escaping (Base) -> () -> Void) -> Binder<Value> {
    .init(target: base) { base, _ in
      action(base)()
    }
  }

  subscript<Value>(_ action: @escaping (Base) -> (Value) -> Void) -> Binder<Value> {
    .init(target: base) { base, value in
      action(base)(value)
    }
  }

  subscript<A, B>(_ action: @escaping (Base) -> (A, B) -> Void) -> Binder<(A, B)> {
    .init(target: base) { base, args in
      action(base)(args.0, args.1)
    }
  }

  subscript<A, B, C>(_ action: @escaping (Base) -> (A, B, C) -> Void) -> Binder<(A, B, C)> {
    .init(target: base) { base, args in
      action(base)(args.0, args.1, args.2)
    }
  }

  subscript<A, B, C, D>(_ action: @escaping (Base) -> (A, B, C, D) -> Void) -> Binder<(A, B, C, D)> {
    .init(target: base) { base, args in
      action(base)(args.0, args.1, args.2, args.3)
    }
  }

  subscript<A, B, C, D, E>(_ action: @escaping (Base) -> (A, B, C, D, E) -> Void) -> Binder<(A, B, C, D, E)> {
    .init(target: base) { base, args in
      action(base)(args.0, args.1, args.2, args.3, args.4)
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Combine where Base: AnyObject & BindingProvider {
  subscript(_ action: ((Base) -> Void)?) -> Binder<Void> {
    .init(target: base) { base, _ in
      action?(base)
    }
  }

  subscript<Value>(_ action: ((Base) -> Void)?) -> Binder<Value> {
    .init(target: base) { base, _ in
      action?(base)
    }
  }

  subscript<Value>(_ action: ((Base, Value) -> Void)?) -> Binder<Value> {
    .init(target: base) { base, value in
      action?(base, value)
    }
  }

  subscript<A, B>(_ action: ((Base, A, B) -> Void)?) -> Binder<(A, B)> {
    .init(target: base) { base, args in
      action?(base, args.0, args.1)
    }
  }

  subscript<A, B, C>(_ action: ((Base, A, B, C) -> Void)?) -> Binder<(A, B, C)> {
    .init(target: base) { base, args in
      action?(base, args.0, args.1, args.2)
    }
  }

  subscript<A, B, C, D>(_ action: ((Base, A, B, C, D) -> Void)?) -> Binder<(A, B, C, D)> {
    .init(target: base) { base, args in
      action?(base, args.0, args.1, args.2, args.3)
    }
  }

  subscript<A, B, C, D, E>(_ action: ((Base, A, B, C, D, E) -> Void)?) -> Binder<(A, B, C, D, E)> {
    .init(target: base) { base, args in
      action?(base, args.0, args.1, args.2, args.3, args.4)
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Combine where Base: AnyObject & BindingProvider {
  subscript<Element>(_ keyPath: ReferenceWritableKeyPath<Base, Element>) -> Binder<Element> {
    .init(target: base) { base, value in
      base[keyPath: keyPath] = value
    }
  }

  subscript<Element>(_ keyPath: ReferenceWritableKeyPath<Base, Element?>) -> Binder<Element?> {
    .init(target: base) { base, value in
      base[keyPath: keyPath] = value
    }
  }
}
#endif
