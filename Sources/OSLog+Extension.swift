import os
import Foundation

public struct Log {
    public enum Level: UInt8, CaseIterable {
        case debug
        case info
        case error

        var stringValue: String {
            switch self {
            case .debug:
                return "DEBUG"
            case .info:
                return "INFO"
            case .error:
                return "ERROR"
            }
        }

        @available(OSX 10.14, iOS 10.0, watchOS 5.0, tvOS 12.0, *)
        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .error:
                return .error
            }
        }
    }

    public static var activeLevel: Level?

    @available(OSX 10.14, iOS 10.0, watchOS 5.0, tvOS 12.0, *)
    public static func out(
        _ message: @autoclosure () -> Any,
        label: String? = nil,
        level: Level = .info,
        provider: LogProvider = OSLog.default,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        if let activeLevel = activeLevel, level.rawValue < activeLevel.rawValue {
            return
        }

        var message = String(describing: message())
        if let label = label {
            message = "#\(label)・" + message
        }

        #if DEBUG
        let result = String(
            format: "%@・%@:%i・%@",
            level.stringValue,
            NSString(string: file).lastPathComponent,
            line,
            message
        )
        #else
        let result = String(
            format: "%@・%@:%@:%i・%@",
            level.stringValue,
            NSString(string: file).lastPathComponent,
            function,
            line,
            message
        )
        #endif

        os_log("%{public}@", log: provider.log, type: level.osLogType, result)
    }

    @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
    public static func begin(_ name: StaticString, identifier: AnyObject? = nil, provider: LogProvider = OSLog.pointsOfInterest) {
        let signpostID: OSSignpostID = nil != identifier ? OSSignpostID(log: provider.log, object: identifier!) : .exclusive
        os_signpost(.begin, log: provider.log, name: name, signpostID: signpostID)
    }

    @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
    public static func end(_ name: StaticString, identifier: AnyObject? = nil, provider: LogProvider = OSLog.pointsOfInterest) {
        let signpostID: OSSignpostID = nil != identifier ? OSSignpostID(log: provider.log, object: identifier!) : .exclusive
        os_signpost(.end, log: provider.log, name: name, signpostID: signpostID)
    }

    @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
    public static func event(_ name: StaticString, identifier: AnyObject? = nil, provider: LogProvider = OSLog.pointsOfInterest) {
        let signpostID: OSSignpostID = nil != identifier ? OSSignpostID(log: provider.log, object: identifier!) : .exclusive
        os_signpost(.event, log: provider.log, name: name, signpostID: signpostID)
    }
}

extension OSLog {
    @available(OSX 10.14, iOS 10.0, watchOS 5.0, tvOS 12.0, *)
    public convenience init(category: String) {
        self.init(subsystem: Bundle.main.bundleIdentifier ?? "bar.foor", category: category)
    }

    @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
    public convenience init(category: Category) {
        self.init(subsystem: Bundle.main.bundleIdentifier ?? "bar.foo", category: category)
    }

    @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
    public static let pointsOfInterest = OSLog(subsystem: (Bundle.main.bundleIdentifier ?? "bar.foor") + ".activities", category: .pointsOfInterest)
}

@available(OSX 10.14, iOS 10.0, watchOS 5.0, tvOS 12.0, *)
public protocol LogProvider {
    var log: OSLog { get }
}

@available(OSX 10.14, iOS 10.0, watchOS 5.0, tvOS 12.0, *)
extension OSLog: LogProvider {
    public var log: OSLog {
        return self
    }
}
