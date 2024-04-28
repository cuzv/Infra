import CoreGraphics

public extension CGPoint {
  static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }

  static func += (lhs: inout CGPoint, rhs: CGPoint) {
    lhs = lhs + rhs
  }

  static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }

  static func -= (lhs: inout CGPoint, rhs: CGPoint) {
    lhs = lhs - rhs
  }

  static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    .init(x: point.x * scalar, y: point.y * scalar)
  }

  static func *= (point: inout CGPoint, scalar: CGFloat) {
    point = point * scalar
  }

  static func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
    point.applying(.init(translationX: scalar, y: scalar))
  }
}

public extension CGPoint {
  init(value: CGFloat) {
    self.init(x: value, y: value)
  }

  init(x: CGFloat) {
    self.init(x: x, y: 0)
  }

  init(y: CGFloat) {
    self.init(x: 0, y: y)
  }
}

extension CGPoint: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: IntegerLiteralType) {
    self = .init(value: CGFloat(value))
  }
}

extension CGPoint: ExpressibleByFloatLiteral {
  public init(floatLiteral value: FloatLiteralType) {
    self = .init(value: value)
  }
}

extension CGPoint: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: CGFloat...) {
    self = .init(
      x: elements[0, default: 0],
      y: elements[1, default: 0]
    )
  }
}
