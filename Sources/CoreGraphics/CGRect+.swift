import CoreGraphics

extension CGRect {
  public init(center: CGPoint, size: CGSize) {
    let translation = size.applying(.init(scaleX: -0.5, y: -0.5))
    let origin = center.applying(.init(translationX: translation.width, y: translation.height))
    self.init(origin: origin, size: size)
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

  public func scaled(aspectFit boundingRect: CGRect) -> CGRect {
    precondition(width != 0)
    precondition(height != 0)

    let scale = min(boundingRect.width / width, boundingRect.height / height)
    let targetSize = size.applying(.init(scaleX: scale, y: scale))
    return .init(center: boundingRect.center, size: targetSize)
  }

  public func scaled(aspectFill boundingRect: CGRect) -> CGRect {
    precondition(width != 0)
    precondition(height != 0)

    let scale = max(boundingRect.width / width, boundingRect.height / height)
    let targetSize = size.applying(.init(scaleX: scale, y: scale))
    return .init(center: boundingRect.center, size: targetSize)
  }

  public func center(within boundingRect: CGRect) -> CGRect {
    offsetBy(dx: boundingRect.midX - midX, dy: boundingRect.midY - midY)
  }
}
