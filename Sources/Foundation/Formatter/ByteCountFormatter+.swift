import Foundation

public extension ByteCountFormatter {
  convenience init(
    countStyle: ByteCountFormatter.CountStyle,
    allowedUnits: ByteCountFormatter.Units
  ) {
    self.init()
    self.allowedUnits = allowedUnits
    self.countStyle = countStyle
  }

  static let file = ByteCountFormatter(countStyle: .file, allowedUnits: [.useTB, .useGB, .useMB])
  static let memory = ByteCountFormatter(countStyle: .memory, allowedUnits: [.useTB, .useGB, .useMB])
  static let binary = ByteCountFormatter(countStyle: .binary, allowedUnits: [.useTB, .useGB, .useMB])
}
