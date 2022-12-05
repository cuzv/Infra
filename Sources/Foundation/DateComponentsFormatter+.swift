import Foundation

public extension DateComponentsFormatter {
  convenience init(
    allowedUnits: NSCalendar.Unit,
    unitsStyle: UnitsStyle,
    zeroFormattingBehavior: ZeroFormattingBehavior
  ) {
    self.init()
    self.allowedUnits = allowedUnits
    self.unitsStyle = unitsStyle
    self.zeroFormattingBehavior = zeroFormattingBehavior
  }
}
