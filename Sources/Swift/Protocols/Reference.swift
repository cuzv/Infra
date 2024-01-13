import Foundation

public protocol Reference: AnyObject {}

extension NSObject: Reference {}

public extension Reference {
  func weak(_ action: @escaping (Self) -> () -> Void) -> () -> Void {
    { [weak base = self] in
      if let target = base {
        action(target)()
      }
    }
  }

  func weak<Value>(_ action: @escaping (Self) -> (Value) -> Void) -> (Value) -> Void {
    { [weak base = self] value in
      if let target = base {
        action(target)(value)
      }
    }
  }

  func weak<A, B>(_ action: @escaping (Self) -> (A, B) -> Void) -> (A, B) -> Void {
    { [weak base = self] a, b in
      if let target = base {
        action(target)(a, b)
      }
    }
  }

  func weak<A, B, C>(_ action: @escaping (Self) -> (A, B, C) -> Void) -> (A, B, C) -> Void {
    { [weak base = self] a, b, c in
      if let target = base {
        action(target)(a, b, c)
      }
    }
  }

  func weak<A, B, C, D>(_ action: @escaping (Self) -> (A, B, C, D) -> Void) -> (A, B, C, D) -> Void {
    { [weak base = self] a, b, c, d in
      if let target = base {
        action(target)(a, b, c, d)
      }
    }
  }

  func weak<A, B, C, D, E>(_ action: @escaping (Self) -> (A, B, C, D, E) -> Void) -> (A, B, C, D, E) -> Void {
    { [weak base = self] a, b, c, d, e in
      if let target = base {
        action(target)(a, b, c, d, e)
      }
    }
  }
}

public extension Reference {
  func weak<In, Out>(_ action: @escaping (Self) -> (In) -> Out, defaultValue: @autoclosure @escaping () -> Out) -> (In) -> Out {
    { [weak base = self] input in
      if let target = base {
        action(target)(input)
      } else {
        defaultValue()
      }
    }
  }
}

public extension Reference {
  func unowned(_ action: @escaping (Self) -> () -> Void) -> () -> Void {
    { [unowned base = self] in
      action(base)()
    }
  }

  func unowned<Value>(_ action: @escaping (Self) -> (Value) -> Void) -> (Value) -> Void {
    { [unowned base = self] value in
      action(base)(value)
    }
  }

  func unowned<A, B>(_ action: @escaping (Self) -> (A, B) -> Void) -> (A, B) -> Void {
    { [unowned base = self] a, b in
      action(base)(a, b)
    }
  }

  func unowned<A, B, C>(_ action: @escaping (Self) -> (A, B, C) -> Void) -> (A, B, C) -> Void {
    { [unowned base = self] a, b, c in
      action(base)(a, b, c)
    }
  }

  func unowned<A, B, C, D>(_ action: @escaping (Self) -> (A, B, C, D) -> Void) -> (A, B, C, D) -> Void {
    { [unowned base = self] a, b, c, d in
      action(base)(a, b, c, d)
    }
  }

  func unowned<A, B, C, D, E>(_ action: @escaping (Self) -> (A, B, C, D, E) -> Void) -> (A, B, C, D, E) -> Void {
    { [unowned base = self] a, b, c, d, e in
      action(base)(a, b, c, d, e)
    }
  }
}
