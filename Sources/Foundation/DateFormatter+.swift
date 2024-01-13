import Foundation

public extension DateFormatter {
  convenience init(
    dateStyle: Style,
    timeStyle: Style
  ) {
    self.init()
    self.dateStyle = dateStyle
    self.timeStyle = timeStyle
  }
}
