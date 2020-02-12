import CoreGraphics

extension CGPoint {
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs
    }

    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs - rhs
    }

    public static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        .init(x: point.x * scalar, y: point.y * scalar)
    }

    public static func *= (point: inout CGPoint, scalar: CGFloat) {
        point = point * scalar
    }

    public static func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
        point.applying(.init(translationX: scalar, y: scalar))
    }
}
