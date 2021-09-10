import Foundation

// https://gist.github.com/onevcat/0f055ece50bd0c07e882890129dfcfb8
// https://www.swiftbysundell.com/tips/default-decoding-values/

public protocol DecodableDefaultSource {
  associatedtype Value: Decodable
  static var defaultValue: Value { get }
}

public enum DecodableDefault {}

extension DecodableDefault {
  @propertyWrapper
  public struct Wrapper<Source: DecodableDefaultSource> {
    public var wrappedValue: Source.Value

    public init(wrappedValue: Source.Value) {
      self.wrappedValue = wrappedValue
    }
  }
}

extension DecodableDefault.Wrapper: CustomStringConvertible {
  public var description: String {
    if let value = wrappedValue as? CustomStringConvertible {
      return value.description
    }
    return "\(wrappedValue)"
  }
}

extension DecodableDefault.Wrapper: CustomDebugStringConvertible {
  public var debugDescription: String {
    description
  }
}

extension DecodableDefault.Wrapper: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    wrappedValue = try container.decode(Source.Value.self)
  }
}

extension KeyedDecodingContainer {
  public func decode<Source>(
    _ type: DecodableDefault.Wrapper<Source>.Type,
    forKey key: Key
  ) throws -> DecodableDefault.Wrapper<Source> {
    try decodeIfPresent(type, forKey: key) ?? .init(wrappedValue: Source.defaultValue)
  }
}

extension DecodableDefault.Wrapper: Equatable where Source.Value: Equatable {}
extension DecodableDefault.Wrapper: Hashable where Source.Value: Hashable {}

extension DecodableDefault.Wrapper: Encodable where Source.Value: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue)
  }
}

// MARK: -

extension DecodableDefault {
  public typealias Source = DecodableDefaultSource
  public typealias List = Decodable & ExpressibleByArrayLiteral
  public typealias Map = Decodable & ExpressibleByDictionaryLiteral

  public enum Sources {
    public enum True: Source {
      public static var defaultValue: Bool { true }
    }

    public enum False: Source {
      public static var defaultValue: Bool { false }
    }

    public enum EmptyList<T: List>: Source {
      public static var defaultValue: T { [] }
    }

    public enum EmptyMap<T: Map>: Source {
      public static var defaultValue: T { [:] }
    }

    public enum Timestamp: Source {
      public static var defaultValue: Double { Date().timeIntervalSince1970 }
    }
  }
}

extension String: DecodableDefaultSource {
  public static let defaultValue: Self = ""
}

extension Int: DecodableDefaultSource {
  public static let defaultValue: Self = 0
}

extension Int64: DecodableDefaultSource {
  public static let defaultValue: Self = 0
}

extension Double: DecodableDefaultSource {
  public static let defaultValue: Self = 0
}

extension Float: DecodableDefaultSource {
  public static let defaultValue: Self = 0
}

extension URL: DecodableDefaultSource {
  public static let defaultValue: Self = URL(string: "https://httpbin.org/")!
}

extension DecodableDefault {
  public typealias True = Wrapper<Sources.True>
  public typealias False = Wrapper<Sources.False>
  public typealias Arr<T: List> = Wrapper<Sources.EmptyList<T>>
  public typealias Dic<T: Map> = Wrapper<Sources.EmptyMap<T>>
  public typealias Str = Wrapper<String>
  public typealias Integer = Wrapper<Int>
  public typealias Integer64 = Wrapper<Int64>
  public typealias Dbl = Wrapper<Double>
  public typealias Flt = Wrapper<Float>
  public typealias Url = Wrapper<URL>
  public typealias Timestamp = Wrapper<Sources.Timestamp>
}

// MARK: -

/**
 public struct Video: Codable {
 enum State: String, Codable, DecodableDefaultSource {
 case streaming
 case archived
 case unknown
 static let defaultValue = Video.State.unknown
 }

 struct State2: RawRepresentable, Codable {
 static let streaming = State2(rawValue: "streaming")
 static let archived = State2(rawValue: "archived")

 let rawValue: String
 }

 @DecodableDefault.Integer64 private(set) var id2: Int64 = 0
 @DecodableDefault.Integer private(set) var id: Int = 0
 @DecodableDefault.Flt private(set) var flt: Float = 0
 @DecodableDefault.Dbl private(set) var time: Double = 0
 @DecodableDefault.False private(set) var commentEnabled: Bool = false
 @DecodableDefault.True private(set) var publicVideo: Bool = true
 @DecodableDefault.Str private(set) var title: String = ""
 @DecodableDefault.Dic var flags2: [String : Bool]
 @DecodableDefault.Arr var comments: [String]
 @DecodableDefault.Arr private(set) var states: [State]
 @DecodableDefault.State private(set) var state: State
 @DecodableDefault.Wrapper<State> private(set) var state2: State
 }

 extension DecodableDefault {
 typealias State = Wrapper<Video.State>
 }
 */
