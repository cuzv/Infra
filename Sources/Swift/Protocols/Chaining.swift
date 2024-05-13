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

  @inlinable
  @discardableResult
  func assigning(
    _ value: inout Self?
  ) -> Self {
    value = self
    return self
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

  @inlinable
  @discardableResult
  func assigning(
    _ value: inout Self?
  ) -> Self {
    value = self
    return self
  }
}

// MARK: - Mutation

public extension Chaining where Self: Any {
  @inlinable
  @discardableResult
  func with(
    _ mutation: (inout Self) throws -> Void
  ) rethrows -> Self {
    var this = self
    try mutation(&this)
    return this
  }
}

public extension Chaining where Self: AnyObject {
  @inlinable
  @discardableResult
  func with(
    _ operation: (Self) throws -> Void
  ) rethrows -> Self {
    try operation(self)
    return self
  }
}

public extension Chaining where Self: Any & Sendable {
  @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
  @Sendable
  func with(
    _ mutation: @Sendable (inout Self) async throws -> Void
  ) async rethrows -> Self {
    var this = self
    try await mutation(&this)
    return this
  }
}

public extension Chaining where Self: AnyObject & Sendable {
  @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
  @Sendable
  @discardableResult
  func with(
    _ operation: @Sendable (Self) async throws -> Void
  ) async rethrows -> Self {
    try await operation(self)
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
