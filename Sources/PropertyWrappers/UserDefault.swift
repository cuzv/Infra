// Copied from https://github.com/ole/PropertyWrappers/blob/master/Sources/PropertyWrappers/UserDefault.swift

import Foundation

/// A property wrapper that stores its value directly in user defaults.
///
/// The `Value` type specifies how it stores itself as a property list object
/// via its `PropertyListConvertible` conformance. To store your own type in user defaults,
/// conform it to `PropertyListConvertible`.
///
/// Usage:
///
///     @UserDefault(key: "locationTrackingEnabled", defaultValue: false)
///     var isLocationTrackingEnabled: Bool
///
///     @UserDefault(key: "colorScheme", defaultValue: .solarizedDark)
///     var colorScheme: ColorScheme
///
/// Unless otherwise specified, defaults values are read from and written to `UserDefaults.standard`.
/// You can override this by passing an explicit `UserDefaults` instance to the initializer:
///
///     @UserDefault var localeIdentifier: String
///     ...
///     let myDefaults = UserDefaults(...)
///     $localeIdentifier = (key: "localeIdentifier", defaultValue: "en_US", userDefaults: myDefaults)
///
/// Source: Extended from a base implementation shown in [Swift Evolution proposal SE-0258](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md)
@propertyWrapper
public struct UserDefault<Value: PropertyListConvertible> {
  public let key: String
  public let defaultValue: () -> Value
  public let userDefaults: UserDefaults

  public init(key: String, defaultValue: @autoclosure @escaping () -> Value, userDefaults: UserDefaults = .standard) {
    self.key = key
    self.defaultValue = defaultValue
    self.userDefaults = userDefaults
    // Register default value with user defaults
    if let defaultValue = defaultValue() as? Optionality {
      /// `nil` or `NSNull` are not valid property list values.
      // This means we can't register a `nil` default value and we can't distinguish between
      // "value not present" and "values was explicitly set to nil". This makes `nil` the only
      // safe choice as a default value.
      precondition(defaultValue.isNil, """
        The default value for optional UserDefault properties must be nil. \
        nil or NSNull are not valid property list values. This means we can't distinguish between \
        "value not present" and "values was explicitly set to nil". \
        This makes `nil` the only safe choice as a default value.
        """)
      // Do nothing else. We can't register `nil` as the default value.
    } else {
      userDefaults.register(defaults: [key: defaultValue().propertyListValue])
    }
  }

  public var wrappedValue: Value {
    get {
      // If `Value.Storage == [String: PropertyListNativelyStorable]`, the direct cast from
      // from Any to Value.Storage fails, but it works when inserting an intermediate cast to
      // [String: Any]. I don't know why.
      guard let plistValue = (userDefaults.object(forKey: key) as? Value.Storage) ?? ((userDefaults.object(forKey: key) as? [String: Any]) as? Value.Storage),
            let value = Value(propertyListValue: plistValue)
      else { return defaultValue() }
      return value
    }
    nonmutating set {
      if let optional = newValue as? Optionality, optional.isNil {
        userDefaults.removeObject(forKey: key)
      } else {
        userDefaults.set(newValue.propertyListValue, forKey: key)
      }
    }
  }
}

// MARK: - PropertyListConvertible

/// A type that can convert itself to and from a plist-compatible type (for storage in a plist).
public protocol PropertyListConvertible {
  /// The type that's used for storage in the plist.
  associatedtype Storage: PropertyListNativelyStorable

  /// Creates an instance from its property list representation.
  ///
  /// The default implementation for PropertyListStorage == Self uses `propertyListValue` directly as `self`.
  ///
  /// - Returns: `nil` if the conversion failed.
  init?(propertyListValue plistValue: Storage)

  /// The property list representation of `self`.
  /// The default implementation for PropertyListStorage == Self returns `self`.
  var propertyListValue: Storage { get }
}

/// Default implementation for native property list types that don't need any conversion.
public extension PropertyListConvertible where Storage == Self {
  init?(propertyListValue plistValue: Self) {
    self = plistValue
  }

  var propertyListValue: Self { self }
}

extension String: PropertyListConvertible { public typealias Storage = Self }
extension Int: PropertyListConvertible { public typealias Storage = Self }
extension Int8: PropertyListConvertible { public typealias Storage = Self }
extension Int16: PropertyListConvertible { public typealias Storage = Self }
extension Int32: PropertyListConvertible { public typealias Storage = Self }
extension Int64: PropertyListConvertible { public typealias Storage = Self }
extension UInt: PropertyListConvertible { public typealias Storage = Self }
extension UInt8: PropertyListConvertible { public typealias Storage = Self }
extension UInt16: PropertyListConvertible { public typealias Storage = Self }
extension UInt32: PropertyListConvertible { public typealias Storage = Self }
extension UInt64: PropertyListConvertible { public typealias Storage = Self }
extension Float: PropertyListConvertible { public typealias Storage = Self }
extension Double: PropertyListConvertible { public typealias Storage = Self }
extension Bool: PropertyListConvertible { public typealias Storage = Self }
extension Date: PropertyListConvertible { public typealias Storage = Self }
extension Data: PropertyListConvertible { public typealias Storage = Self }

/// Default implementation for Codable types that can encode themselves as a dictionary.
///
/// The implementation uses `PropertyListEncoder` and `PropertyListDecoder` to encode/decode
/// values for storage in user defaults.
///
/// To declare that you want to use this default implementation, add the conformance and an
/// explicit type alias for the `PropertyListConvertible.Storage` associated type:
///
///     extension MyCustomType: PropertyListConvertible {
///       typealias Storage = [String: PropertyListNativelyStorable]
///     }
///
/// - Note: You must ensure that your type encodes itself as a dictionary
///   (`KeyedEncodingContainer`) and not as an array (`UnkeyedEncodingContainer`) or as a
///   single value (`SingleValueEncodingContainer`).
public extension PropertyListConvertible where Self: Codable, Self.Storage == [String: PropertyListNativelyStorable] {
  init?(propertyListValue plistDict: [String: PropertyListNativelyStorable]) {
    let decoder = PropertyListDecoder()
    do {
      let plistData = try PropertyListSerialization.data(fromPropertyList: plistDict, format: .binary, options: 0)
      let parsedValue = try decoder.decode(Self.self, from: plistData)
      self = parsedValue
    } catch {
      assertionFailure("Unable to decode plist dictionary for type \(Self.self) stored in user defaults")
      return nil
    }
  }

  var propertyListValue: [String: PropertyListNativelyStorable] {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .binary
    do {
      let plistData = try encoder.encode(self)
      guard let plist = try (PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: Any])?.compactMapValues({ $0 as? PropertyListNativelyStorable }) else {
        assertionFailure("Property list representation of \(Self.self) must be a string-keyed dictionary")
        return [:]
      }
      return plist
    } catch {
      assertionFailure("Unable to create property list representation for type \(Self.self) for storage in user defaults")
      return [:]
    }
  }
}

/// UUID stores itself as a String
extension UUID: PropertyListConvertible {
  public var propertyListValue: String { uuidString }

  public init?(propertyListValue plistString: String) {
    self.init(uuidString: plistString)
  }
}

/// Optionals can be stored in a property list if they wrap a PropertyListConvertible type
///
/// - Note: The default value for optional UserDefault properties must be `nil`.
///   `nil` or `NSNull` are not valid property list values. This means we can't distinguish between
///   "value not present" and "values was explicitly set to nil".
///   This makes `nil` the only safe choice as a default value.
extension Optional: PropertyListConvertible where Wrapped: PropertyListConvertible {
  public init?(propertyListValue plistValue: Wrapped.Storage?) {
    guard let storedValue = plistValue else { return nil }
    self = Wrapped(propertyListValue: storedValue)
  }

  public var propertyListValue: Wrapped.Storage? {
    self?.propertyListValue
  }
}

/// Arrays convert themselves to their property list representation by converting each element to
/// its plist representation.
extension Array: PropertyListConvertible where Element: PropertyListConvertible {
  /// Returns `nil` if one or more elements can't be converted.
  public init?(propertyListValue plistArray: [Element.Storage]) {
    var result: [Element] = []
    result.reserveCapacity(plistArray.count)
    for plistElement in plistArray {
      guard let element = Element(propertyListValue: plistElement) else {
        // Abort if one or more elements can't be created.
        return nil
      }
      result.append(element)
    }
    self = result
  }

  public var propertyListValue: [Element.Storage] {
    map(\.propertyListValue)
  }
}

extension Dictionary: PropertyListConvertible where Key == String, Value: PropertyListConvertible {
  /// Returns `nil` if one or more elements can't be converted.
  public init?(propertyListValue plistDict: [Key: Value.Storage]) {
    var result: [Key: Value] = [:]
    result.reserveCapacity(plistDict.count)
    for (key, plistValue) in plistDict {
      guard let value = Value(propertyListValue: plistValue) else {
        // Abort if one or more elements can't be created.
        return nil
      }
      result[key] = value
    }
    self = result
  }

  public var propertyListValue: [Key: Value.Storage] {
    mapValues { value in
      value.propertyListValue
    }
  }
}

// MARK: - PropertyListNativelyStorable

/// A type that can be natively stored in a property list, i.e. a _property list object_.
///
/// This is a marker protocol, i.e. it has no requirements. You should not conform your own types to it.
/// We already provide the required conformances for the standard plist-compatible types.
///
/// Instances of these types can be property list objects:
///
/// - Dictionary/NSDictionary (Key must be String, Value must be a plist type)
/// - Array/NSArray (Element must be a plist type)
/// - String/NSString
/// - A numeric type that's convertible to NSNumber
/// - Bool
/// - Date/NSDate
/// - Data/NSData
///
/// See https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/PropertyList.html
public protocol PropertyListNativelyStorable {}

extension String: PropertyListNativelyStorable {}
extension Int: PropertyListNativelyStorable {}
extension Int8: PropertyListNativelyStorable {}
extension Int16: PropertyListNativelyStorable {}
extension Int32: PropertyListNativelyStorable {}
extension Int64: PropertyListNativelyStorable {}
extension UInt: PropertyListNativelyStorable {}
extension UInt8: PropertyListNativelyStorable {}
extension UInt16: PropertyListNativelyStorable {}
extension UInt32: PropertyListNativelyStorable {}
extension UInt64: PropertyListNativelyStorable {}
extension Float: PropertyListNativelyStorable {}
extension Double: PropertyListNativelyStorable {}
extension Bool: PropertyListNativelyStorable {}
extension Date: PropertyListNativelyStorable {}
extension Data: PropertyListNativelyStorable {}

extension NSNumber: PropertyListNativelyStorable {}
extension NSString: PropertyListNativelyStorable {}
extension NSDate: PropertyListNativelyStorable {}
extension NSData: PropertyListNativelyStorable {}
extension NSArray: PropertyListNativelyStorable {}
extension NSDictionary: PropertyListNativelyStorable {}

extension Optional: PropertyListNativelyStorable where Wrapped: PropertyListNativelyStorable {}

extension Array: PropertyListNativelyStorable where Element: PropertyListNativelyStorable {}

extension Dictionary: PropertyListNativelyStorable where Key == String {}
