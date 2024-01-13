import Foundation
import os

public enum Log {
  public enum Level: UInt8, CaseIterable {
    case debug
    case info
    case error

    var stringValue: String {
      switch self {
      case .debug:
        "DEBUG"
      case .info:
        "INFO"
      case .error:
        "ERROR"
      }
    }

    @available(OSX 10.14, iOS 10.0, watchOS 5.0, tvOS 12.0, *)
    var osLogType: OSLogType {
      switch self {
      case .debug:
        .debug
      case .info:
        .info
      case .error:
        .error
      }
    }
  }

  public static var activeLevel: Level?

  @available(OSX 10.14, iOS 10.0, watchOS 5.0, tvOS 12.0, *)
  public static func out(
    _ message: @autoclosure () -> Any,
    label: String? = nil,
    level: Level = .debug,
    provider: LogProvider = OSLog.default,
    file: String = #file,
    function: String = #function,
    line: Int = #line
  ) {
    if let activeLevel, level.rawValue < activeLevel.rawValue {
      return
    }

    var message = String(describing: message())
    if let label {
      message = "#\(label)・" + message
    }

    let result = String(
      format: "%@・%@:%i:%@・%@",
      level.stringValue,
      NSString(string: file).lastPathComponent,
      line,
      function,
      message
    )

    os_log("%{public}@", log: provider.log, type: level.osLogType, result)
  }

  @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
  public static func begin(
    _ name: StaticString,
    identifier: AnyObject? = nil,
    provider: LogProvider = OSLog.pointsOfInterest
  ) {
    let signpostID: OSSignpostID = identifier != nil ?
      OSSignpostID(log: provider.log, object: identifier!) :
      .exclusive
    os_signpost(.begin, log: provider.log, name: name, signpostID: signpostID)
  }

  @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
  public static func end(
    _ name: StaticString,
    identifier: AnyObject? = nil,
    provider: LogProvider = OSLog.pointsOfInterest
  ) {
    let signpostID: OSSignpostID = identifier != nil ?
      OSSignpostID(log: provider.log, object: identifier!) :
      .exclusive
    os_signpost(.end, log: provider.log, name: name, signpostID: signpostID)
  }

  @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
  public static func event(
    _ name: StaticString,
    identifier: AnyObject? = nil,
    provider: LogProvider = OSLog.pointsOfInterest
  ) {
    let signpostID: OSSignpostID = identifier != nil ?
      OSSignpostID(log: provider.log, object: identifier!) :
      .exclusive
    os_signpost(.event, log: provider.log, name: name, signpostID: signpostID)
  }
}

public extension OSLog {
  @available(OSX 10.14, iOS 10.0, watchOS 5.0, tvOS 12.0, *)
  convenience init(category: String) {
    self.init(
      subsystem: Bundle.main.bundleIdentifier ?? "com.redrainlab",
      category: category
    )
  }

  @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
  convenience init(category: Category) {
    self.init(
      subsystem: Bundle.main.bundleIdentifier ?? "com.redrainlab",
      category: category
    )
  }

  @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
  static let pointsOfInterest = OSLog(
    subsystem: (Bundle.main.bundleIdentifier ?? "com.redrainlab") + ".activities",
    category: .pointsOfInterest
  )
}

@available(OSX 10.14, iOS 10.0, watchOS 5.0, tvOS 12.0, *)
public protocol LogProvider {
  var log: OSLog { get }
}

@available(OSX 10.14, iOS 10.0, watchOS 5.0, tvOS 12.0, *)
public extension LogProvider {
  func out(
    _ message: @autoclosure () -> Any,
    label: String? = nil,
    level: Log.Level = .debug,
    file: String = #file,
    function: String = #function,
    line: Int = #line
  ) {
    Log.out(
      message(),
      label: label,
      level: level,
      provider: self,
      file: file,
      function: function,
      line: line
    )
  }
}

@available(OSX 10.14, iOS 10.0, watchOS 5.0, tvOS 12.0, *)
extension OSLog: LogProvider {
  public var log: OSLog {
    self
  }
}
