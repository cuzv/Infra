import Foundation
#if !os(Linux)
import CoreGraphics
#endif
#if os(iOS) || os(tvOS)
import UIKit.UIGeometry
#endif

public protocol Chaining {
}

// MARK: - Assignment

extension Chaining where Self: Any {
  @inline(__always)
  @discardableResult
  public func assigning<T>(
    _ value: T,
    to keyPath: WritableKeyPath<Self, T>
  ) -> Self {
    var this = self
    this[keyPath: keyPath] = value
    return this
  }

  @inline(__always)
  @discardableResult
  public func assigning<M, T>(
    _ value: T,
    to keyPath: WritableKeyPath<M, T>,
    on memeber: WritableKeyPath<Self, M>
  ) -> Self {
    var this = self
    var m = this[keyPath: memeber]
    m[keyPath: keyPath] = value
    this[keyPath: memeber] = m
    return this
  }

  @inline(__always)
  @discardableResult
  public func assigning<M, T>(
    _ value: T,
    to keyPath: WritableKeyPath<M, T>,
    on memeber: WritableKeyPath<Self, M?>
  ) -> Self {
    var this = self
    var m = this[keyPath: memeber]
    m?[keyPath: keyPath] = value
    this[keyPath: memeber] = m
    return this
  }
}

extension Chaining where Self: AnyObject {
  @inline(__always)
  @discardableResult
  public func assigning<T>(
    _ value: T,
    to keyPath: ReferenceWritableKeyPath<Self, T>
  ) -> Self {
    self[keyPath: keyPath] = value
    return self
  }

  @inline(__always)
  @discardableResult
  public func assigning<M, V>(
    _ value: V,
    to keyPath: ReferenceWritableKeyPath<M, V>,
    on member: (Self) -> M
  ) -> Self where M: AnyObject {
    member(self)[keyPath: keyPath] = value
    return self
  }

  @inline(__always)
  @discardableResult
  public func assigning<M, V>(
    _ value: V,
    to keyPath: ReferenceWritableKeyPath<M, V>,
    on member: (Self) -> M?
  ) -> Self where M: AnyObject {
    member(self)?[keyPath: keyPath] = value
    return self
  }
}

// MARK: - Access

extension Chaining where Self: Any {
  @inlinable
  @discardableResult
  public func accessing(
    _ operation: (inout Self) throws -> Void
  ) rethrows -> Self {
    var this = self
    try operation(&this)
    return this
  }
}

extension Chaining where Self: AnyObject {
  @inlinable
  @discardableResult
  public func accessing(
    _ operation: (Self) throws -> Void
  ) rethrows -> Self {
    try operation(self)
    return self
  }
}

// MARK: - Comply

extension NSObject: Chaining {}

#if !os(Linux)
extension CGPoint: Chaining {}
extension CGRect: Chaining {}
extension CGSize: Chaining {}
extension CGVector: Chaining {}
#endif

extension Array: Chaining {}
extension Dictionary: Chaining {}
extension Set: Chaining {}

#if os(iOS) || os(tvOS)
extension UIEdgeInsets: Chaining {}
extension UIOffset: Chaining {}
extension UIRectEdge: Chaining {}
#endif
