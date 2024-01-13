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
