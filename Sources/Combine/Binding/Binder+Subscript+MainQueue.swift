#if !(os(iOS) && (arch(i386) || arch(arm)))
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Combine where Base: AnyObject & BindingProvider {
  subscript(main action: @escaping (Base) -> () -> Void) -> Binder<Void> {
    .init(target: base, receiveOnMainQueue: true) { base, _ in
      action(base)()
    }
  }

  subscript<Value>(main action: @escaping (Base) -> () -> Void) -> Binder<Value> {
    .init(target: base, receiveOnMainQueue: true) { base, _ in
      action(base)()
    }
  }

  subscript<Value>(main action: @escaping (Base) -> (Value) -> Void) -> Binder<Value> {
    .init(target: base, receiveOnMainQueue: true) { base, value in
      action(base)(value)
    }
  }

  subscript<A, B>(main action: @escaping (Base) -> (A, B) -> Void) -> Binder<(A, B)> {
    .init(target: base, receiveOnMainQueue: true) { base, args in
      action(base)(args.0, args.1)
    }
  }

  subscript<A, B, C>(main action: @escaping (Base) -> (A, B, C) -> Void) -> Binder<(A, B, C)> {
    .init(target: base, receiveOnMainQueue: true) { base, args in
      action(base)(args.0, args.1, args.2)
    }
  }

  subscript<A, B, C, D>(main action: @escaping (Base) -> (A, B, C, D) -> Void) -> Binder<(A, B, C, D)> {
    .init(target: base, receiveOnMainQueue: true) { base, args in
      action(base)(args.0, args.1, args.2, args.3)
    }
  }

  subscript<A, B, C, D, E>(main action: @escaping (Base) -> (A, B, C, D, E) -> Void) -> Binder<(A, B, C, D, E)> {
    .init(target: base, receiveOnMainQueue: true) { base, args in
      action(base)(args.0, args.1, args.2, args.3, args.4)
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Combine where Base: AnyObject & BindingProvider {
  subscript(main action: ((Base) -> Void)?) -> Binder<Void> {
    .init(target: base, receiveOnMainQueue: true) { base, _ in
      action?(base)
    }
  }

  subscript<Value>(main action: ((Base) -> Void)?) -> Binder<Value> {
    .init(target: base, receiveOnMainQueue: true) { base, _ in
      action?(base)
    }
  }

  subscript<Value>(main action: ((Base, Value) -> Void)?) -> Binder<Value> {
    .init(target: base, receiveOnMainQueue: true) { base, value in
      action?(base, value)
    }
  }

  subscript<A, B>(main action: ((Base, A, B) -> Void)?) -> Binder<(A, B)> {
    .init(target: base, receiveOnMainQueue: true) { base, args in
      action?(base, args.0, args.1)
    }
  }

  subscript<A, B, C>(main action: ((Base, A, B, C) -> Void)?) -> Binder<(A, B, C)> {
    .init(target: base, receiveOnMainQueue: true) { base, args in
      action?(base, args.0, args.1, args.2)
    }
  }

  subscript<A, B, C, D>(main action: ((Base, A, B, C, D) -> Void)?) -> Binder<(A, B, C, D)> {
    .init(target: base, receiveOnMainQueue: true) { base, args in
      action?(base, args.0, args.1, args.2, args.3)
    }
  }

  subscript<A, B, C, D, E>(main action: ((Base, A, B, C, D, E) -> Void)?) -> Binder<(A, B, C, D, E)> {
    .init(target: base, receiveOnMainQueue: true) { base, args in
      action?(base, args.0, args.1, args.2, args.3, args.4)
    }
  }
}

#endif
