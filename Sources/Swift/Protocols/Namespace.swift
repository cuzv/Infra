public protocol ExtensionsProvider {}

public extension ExtensionsProvider {
  /// A proxy which hosts reactive extensions for `self`.
  var ext: Extnsion<Self> {
    Extnsion(self)
  }

  /// A proxy which hosts static reactive extensions for the type of `self`.
  static var ext: Extnsion<Self>.Type {
    Extnsion<Self>.self
  }
}

/// A proxy which hosts reactive extensions of `Base`.
public struct Extnsion<Base> {
  /// The `Base` instance the extensions would be invoked with.
  public let base: Base

  /// Construct a proxy
  ///
  /// - parameters:
  ///   - base: The object to be proxied.
  fileprivate init(_ base: Base) {
    self.base = base
  }
}

import Foundation.NSObject

extension NSObject: ExtensionsProvider {}
