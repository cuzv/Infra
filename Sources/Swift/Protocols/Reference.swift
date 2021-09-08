import Foundation

public protocol Reference: AnyObject {}

extension NSObject: Reference {}

extension Reference {
  public func weak(_ action: @escaping (Self) -> () -> Void) -> () -> Void {
    return { [weak base = self] in
      if let target = base {
        action(target)()
      }
    }
  }

  public func weak<Value>(_ action: @escaping (Self) -> (Value) -> Void) -> (Value) -> Void {
    return { [weak base = self] value in
      if let target = base {
        action(target)(value)
      }
    }
  }

  public func weak<A, B>(_ action: @escaping (Self) -> (A, B) -> Void) -> (A, B) -> Void {
    return { [weak base = self] a, b in
      if let target = base {
        action(target)(a, b)
      }
    }
  }

  public func weak<A, B, C>(_ action: @escaping (Self) -> (A, B, C) -> Void) -> (A, B, C) -> Void {
    return { [weak base = self] a, b, c in
      if let target = base {
        action(target)(a, b, c)
      }
    }
  }

  public func weak<A, B, C, D>(_ action: @escaping (Self) -> (A, B, C, D) -> Void) -> (A, B, C, D) -> Void {
    return { [weak base = self] a, b, c, d in
      if let target = base {
        action(target)(a, b, c, d)
      }
    }
  }

  public func weak<A, B, C, D, E>(_ action: @escaping (Self) -> (A, B, C, D, E) -> Void) -> (A, B, C, D, E) -> Void {
    return { [weak base = self] a, b, c, d, e in
      if let target = base {
        action(target)(a, b, c, d, e)
      }
    }
  }
}

extension Reference {
  public func weak<In, Out>(_ action: @escaping (Self) -> (In) -> Out, defaultValue: @autoclosure @escaping () -> Out) -> (In) -> Out {
    return { [weak base = self] input in
      if let target = base {
        return action(target)(input)
      } else {
        return defaultValue()
      }
    }
  }
}

extension Reference {
  public func unowned(_ action: @escaping (Self) -> () -> Void) -> () -> Void {
    return { [unowned base = self] in
      action(base)()
    }
  }

  public func unowned<Value>(_ action: @escaping (Self) -> (Value) -> Void) -> (Value) -> Void {
    return { [unowned base = self] value in
      action(base)(value)
    }
  }

  public func unowned<A, B>(_ action: @escaping (Self) -> (A, B) -> Void) -> (A, B) -> Void {
    return { [unowned base = self] a, b in
      action(base)(a, b)
    }
  }

  public func unowned<A, B, C>(_ action: @escaping (Self) -> (A, B, C) -> Void) -> (A, B, C) -> Void {
    return { [unowned base = self] a, b, c in
      action(base)(a, b, c)
    }
  }

  public func unowned<A, B, C, D>(_ action: @escaping (Self) -> (A, B, C, D) -> Void) -> (A, B, C, D) -> Void {
    return { [unowned base = self] a, b, c, d in
      action(base)(a, b, c, d)
    }
  }

  public func unowned<A, B, C, D, E>(_ action: @escaping (Self) -> (A, B, C, D, E) -> Void) -> (A, B, C, D, E) -> Void {
    return { [unowned base = self] a, b, c, d, e in
      action(base)(a, b, c, d, e)
    }
  }
}
