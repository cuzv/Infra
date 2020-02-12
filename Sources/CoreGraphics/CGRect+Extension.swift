import CoreGraphics

extension CGRect {
    public init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - 0.5 * size.width, y: center.y - 0.5 * size.height, width: size.width, height: size.height)
    }

    @inline(__always)
    public var center: CGPoint {
        .init(x: midX, y: midY)
    }

    @inline(__always)
    public var ceiled: CGRect {
        .init(x: ceil(origin.x), y: ceil(origin.y), width: ceil(width), height: ceil(height))
    }

    @inline(__always)
    public var floored: CGRect {
        .init(x: floor(origin.x), y: floor(origin.y), width: floor(width), height: floor(height))
    }

    public func scaleAspectFit(to boundingRect: CGRect) -> CGRect {
        let scale = min(boundingRect.width / width, boundingRect.height / height)
        let targetSize = size.applying(.init(scaleX: scale, y: scale))
        return .init(center: boundingRect.center, size: targetSize)
    }

    public func scaleAspectFill(to boundingRect: CGRect) -> CGRect {
        let scale = max(boundingRect.width / width, boundingRect.height / height)
        let targetSize = size.applying(.init(scaleX: scale, y: scale))
        return .init(center: boundingRect.center, size: targetSize)
    }
}
