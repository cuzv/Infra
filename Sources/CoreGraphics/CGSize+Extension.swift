import CoreGraphics

extension CGSize {
    @inline(__always)
    public var aspectRatio: CGFloat {
        height == 0 ? 0 : width / height
    }

    @inline(__always)
    public var maxDimension: CGFloat {
        max(width, height)
    }

    @inline(__always)
    public var minDimension: CGFloat {
        min(width, height)
    }

    @inline(__always)
    public var ceiled: CGSize {
        .init(width: ceil(width), height: ceil(height))
    }

    @inline(__always)
    public var floored: CGSize {
        .init(width: floor(width), height: floor(height))
    }
}

extension CGSize {
    public func scaleAspectFit(to boundingSize: CGSize) -> CGSize {
        let scale = min(boundingSize.width / width, boundingSize.height / height)
        return applying(CGAffineTransform(scaleX: scale, y: scale))
    }

    public func scaleAspectFill(to boundingSize: CGSize) -> CGSize {
        let scale = max(boundingSize.width / width, boundingSize.height / height)
        let aWidth = min(width * scale, boundingSize.width)
        let aHeight = min(height * scale, boundingSize.height)
        return .init(width: aWidth, height: aHeight)
    }
}

extension CGSize {
    public static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        lhs.applying(.init(translationX: rhs.width, y: rhs.height))
    }

    public static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    public static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        lhs.applying(.init(translationX: -rhs.width, y: -rhs.height))
    }

    public static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }

    public static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        lhs.applying(.init(scaleX: rhs.width, y: rhs.height))
    }

    public static func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
        lhs * CGSize(width: scalar, height: scalar)
    }

    public static func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
        rhs * scalar
    }

    public static func *= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }

    public static func *= (lhs: inout CGSize, scalar: CGFloat) {
        lhs.width *= scalar
        lhs.height *= scalar
    }
}
