import Foundation
#if !os(Linux)
import CoreGraphics
#endif
#if os(iOS) || os(tvOS)
import UIKit.UIGeometry
#endif

public protocol Chaining {}

// MARK: - Assignment

public extension Chaining where Self: Any {
  @inline(__always)
  @discardableResult
  func assigning<V>(
    _ value: V,
    to keyPath: WritableKeyPath<Self, V>
  ) -> Self {
    var this = self
    this[keyPath: keyPath] = value
    return this
  }

  @inline(__always)
  @discardableResult
  func assigning<M, V>(
    _ value: V,
    to keyPath: WritableKeyPath<M, V>,
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
  func assigning<M, V>(
    _ value: V,
    to keyPath: WritableKeyPath<M, V>,
    on memeber: WritableKeyPath<Self, M?>
  ) -> Self {
    var this = self
    var m = this[keyPath: memeber]
    m?[keyPath: keyPath] = value
    this[keyPath: memeber] = m
    return this
  }
}

public extension Chaining where Self: AnyObject {
  @inline(__always)
  @discardableResult
  func assigning<V>(
    _ value: V,
    to keyPath: ReferenceWritableKeyPath<Self, V>
  ) -> Self {
    self[keyPath: keyPath] = value
    return self
  }

  @inline(__always)
  @discardableResult
  func assigning<M, V>(
    _ value: V,
    to keyPath: ReferenceWritableKeyPath<M, V>,
    on member: (Self) -> M
  ) -> Self where M: AnyObject {
    member(self)[keyPath: keyPath] = value
    return self
  }

  @inline(__always)
  @discardableResult
  func assigning<M, V>(
    _ value: V,
    to keyPath: ReferenceWritableKeyPath<M, V>,
    on member: (Self) -> M?
  ) -> Self where M: AnyObject {
    member(self)?[keyPath: keyPath] = value
    return self
  }
}

// MARK: - Access

public extension Chaining where Self: Any {
  @inlinable
  @discardableResult
  func accessing(
    _ operation: (inout Self) throws -> Void
  ) rethrows -> Self {
    var this = self
    try operation(&this)
    return this
  }
}

public extension Chaining where Self: AnyObject {
  @inlinable
  @discardableResult
  func accessing(
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

#if canImport(UIKit)
import UIKit

@available(iOS 15.0, *)
extension UIButton.Configuration: Chaining {}
#endif
