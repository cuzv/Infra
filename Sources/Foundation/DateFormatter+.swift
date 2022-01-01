import Foundation

extension DateFormatter {
  public convenience init(
    dateStyle: Style,
    timeStyle: Style
  ) {
    self.init()
    self.dateStyle = dateStyle
    self.timeStyle = timeStyle
  }
}
