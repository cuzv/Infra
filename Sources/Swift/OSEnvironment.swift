import Foundation
import MachO.ldsyms

public enum OSEnvironment {
  /// Indicates whether the app is from Apple Store or not. Returns false if the app is on simulator,
  /// development environment or sideloaded.
  public static let isFromAppStore: Bool = {
    if isSimulator || isAppStoreReceiptSandbox {
      return false
    }
    if hasSCInfoFolder {
      return true
    }
    return isAppEncrypted && !hasEmbeddedMobileProvision
  }()

  /// Indicates whether the app is a Testflight app. Returns true if the app has sandbox receipt.
  /// Returns false otherwise.
  public static let isAppStoreReceiptSandbox: Bool =
    Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

  /// Indicates whether the app is on simulator or not at runtime depending on the device
  /// architecture.
  public static let isSimulator: Bool = {
#if targetEnvironment(simulator)
    return true
#elseif targetEnvironment(macCatalyst)
    return false
#elseif os(iOS) || os(tvOS)
    return ["x86_64", "i386"].contains(deviceModel)
#elseif os(macOS)
    return false
#else
    return false
#endif
  }()

  /// The current device model. Returns an empty string if device model cannot be retrieved.
  public static let deviceModel: String = {
    var systemInfo = utsname()

    if
      uname(&systemInfo) == 0,
      let nsstring = NSString(
        bytes: &systemInfo.machine,
        length: Int(_SYS_NAMELEN),
        encoding: String.Encoding.ascii.rawValue
      )?.utf8String,
      let code = String(validatingUTF8: nsstring)
    {
      return code
    }

    return "unknown"
  }()

  /// Indicates whether it is running inside an extension or an app.
  public static let isAppExtension: Bool = {
#if os(iOS) || os(tvOS) || os(watchOS)
    return Bundle.main.bundlePath.hasSuffix(".appex")
#elseif os(macOS)
    return false
#endif
  }()
}

extension OSEnvironment {
  private static let isAppEncrypted: Bool = {
    guard let header = (UInt32(0) ..< _dyld_image_count())
      .lazy
      .compactMap(_dyld_get_image_header)
      .filter({ MH_EXECUTE == $0.pointee.filetype })
      .first
    else {
      return false
    }

    let is64Bit = [MH_MAGIC_64, MH_CIGAM_64].contains(header.pointee.magic)
    let stepSize = is64Bit ?
      MemoryLayout<mach_header_64>.stride :
      MemoryLayout<mach_header>.stride
    var cursor = header.withMemoryRebound(
      to: UInt8.self,
      capacity: 1, { $0 }
    ) + stepSize

    var index: UInt32 = 0
    while index < header.pointee.ncmds {
      let segCmd = cursor.withMemoryRebound(
        to: segment_command.self,
        capacity: 1,
        { $0.pointee }
      )

      if is64Bit, segCmd.cmd == LC_ENCRYPTION_INFO_64 {
        let cryptCmd = cursor.withMemoryRebound(
          to: encryption_info_command_64.self,
          capacity: 1,
          { $0.pointee }
        )
        return cryptCmd.cryptid != 0
      }
      if !is64Bit, segCmd.cmd == LC_ENCRYPTION_INFO {
        let cryptCmd = cursor.withMemoryRebound(
          to: encryption_info_command.self,
          capacity: 1,
          { $0.pointee }
        )
        return cryptCmd.cryptid != 0
      }

      cursor += Int(segCmd.cmdsize)
      index += 1
    }

    return false
  }()

  private static let hasSCInfoFolder: Bool = {
#if os(iOS) || os(tvOS) || os(watchOS)
    return FileManager.default.fileExists(
      atPath: Bundle.main.bundleURL.appendingPathComponent("SC_Info").relativePath
    )
#elseif os(macOS)
    return false
#endif
  }()

  private static let hasEmbeddedMobileProvision: Bool = {
#if os(iOS) || os(tvOS) || os(watchOS)
    return !(
      Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") ?? ""
    ).isEmpty
#elseif os(macOS)
    return false
#endif
  }()
}

#if canImport(UIKit)
import UIKit

public extension OSEnvironment {
  /// The current operating system version. Returns an empty string if the system version cannot be
  /// retrieved.
  static let systemVersion: String = {
#if os(iOS)
    return UIDevice.current.systemVersion
#elseif os(tvOS) || os(watchOS) || os(macOS)
    let osVersion = ProcessInfo.processInfo.operatingSystemVersion
    var version = String(
      format: "%d.%d",
      osVersion.majorVersion, osVersion.minorVersion
    )
    if osVersion.patchVersion != 0 {
      version.append(String(format: ".%d", osVersion.patchVersion))
    }
    return version
#endif
  }()

  static let description: String = {
    let info: [String: Any] = [
      "hasEmbeddedMobileProvision": hasEmbeddedMobileProvision,
      "hasSCInfoFolder": hasSCInfoFolder,
      "isAppEncrypted": isAppEncrypted,
      "isAppExtension": isAppExtension,
      "systemVersion": systemVersion,
      "deviceModel": deviceModel,
      "isSimulator": isSimulator,
      "isAppStoreReceiptSandbox": isAppStoreReceiptSandbox,
      "isFromAppStore": isFromAppStore,
    ]
    return "\(info)"
  }()
}
#endif
