import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension RelativeDateTimeFormatter {
  convenience init(
    dateTimeStyle: DateTimeStyle,
    unitsStyle: UnitsStyle
  ) {
    self.init()
    self.dateTimeStyle = dateTimeStyle
    self.unitsStyle = unitsStyle
  }

  static let numericFull = RelativeDateTimeFormatter(dateTimeStyle: .numeric, unitsStyle: .full)
  static let numericSpellOut = RelativeDateTimeFormatter(dateTimeStyle: .numeric, unitsStyle: .spellOut)
  static let numericShort = RelativeDateTimeFormatter(dateTimeStyle: .numeric, unitsStyle: .short)
  static let numericAbbreviated = RelativeDateTimeFormatter(dateTimeStyle: .numeric, unitsStyle: .abbreviated)

  static let namedFull = RelativeDateTimeFormatter(dateTimeStyle: .named, unitsStyle: .full)
  static let namedSpellOut = RelativeDateTimeFormatter(dateTimeStyle: .named, unitsStyle: .spellOut)
  static let namedShort = RelativeDateTimeFormatter(dateTimeStyle: .named, unitsStyle: .short)
  static let namedAbbreviated = RelativeDateTimeFormatter(dateTimeStyle: .named, unitsStyle: .abbreviated)
}
