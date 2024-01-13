import CoreGraphics

public extension CGSize {
  @inline(__always)
  var aspectRatio: CGFloat {
    height == 0 ? 0 : width / height
  }

  @inline(__always)
  var maxDimension: CGFloat {
    max(width, height)
  }

  @inline(__always)
  var minDimension: CGFloat {
    min(width, height)
  }

  @inline(__always)
  var ceiled: CGSize {
    .init(width: ceil(width), height: ceil(height))
  }

  @inline(__always)
  var floored: CGSize {
    .init(width: floor(width), height: floor(height))
  }
}

public extension CGSize {
  /// Equal to size of `AVMakeRect(aspectRatio:insideRect:)`
  func scaled(aspectFit boundingSize: CGSize) -> CGSize {
    precondition(width != 0 && height != 0)
    precondition(boundingSize.width != 0 && boundingSize.height != 0)

    let scale = min(boundingSize.width / width, boundingSize.height / height)
    return applying(.init(scaleX: scale, y: scale))
  }

  func scaled(aspectFill boundingSize: CGSize) -> CGSize {
    precondition(width != 0 && height != 0)
    precondition(boundingSize.width != 0 && boundingSize.height != 0)

    let scale = max(boundingSize.width / width, boundingSize.height / height)
    return applying(.init(scaleX: scale, y: scale))
  }
}

public extension CGSize {
  static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
    lhs.applying(.init(translationX: rhs.width, y: rhs.height))
  }

  static func += (lhs: inout CGSize, rhs: CGSize) {
    lhs.width += rhs.width
    lhs.height += rhs.height
  }

  static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
    lhs.applying(.init(translationX: -rhs.width, y: -rhs.height))
  }

  static func -= (lhs: inout CGSize, rhs: CGSize) {
    lhs.width -= rhs.width
    lhs.height -= rhs.height
  }

  static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
    lhs.applying(.init(scaleX: rhs.width, y: rhs.height))
  }

  static func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
    lhs * CGSize(width: scalar, height: scalar)
  }

  static func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
    rhs * scalar
  }

  static func *= (lhs: inout CGSize, rhs: CGSize) {
    lhs.width *= rhs.width
    lhs.height *= rhs.height
  }

  static func *= (lhs: inout CGSize, scalar: CGFloat) {
    lhs.width *= scalar
    lhs.height *= scalar
  }
}

public extension CGSize {
  init(length: CGFloat) {
    self.init(width: length, height: length)
  }
}
