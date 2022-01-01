import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension RelativeDateTimeFormatter {
  public convenience init(
    dateTimeStyle: DateTimeStyle,
    unitsStyle: UnitsStyle
  ) {
    self.init()
    self.dateTimeStyle = dateTimeStyle
    self.unitsStyle = unitsStyle
  }

  public static let numericFull = RelativeDateTimeFormatter(dateTimeStyle: .numeric, unitsStyle: .full)
  public static let numericSpellOut = RelativeDateTimeFormatter(dateTimeStyle: .numeric, unitsStyle: .spellOut)
  public static let numericShort = RelativeDateTimeFormatter(dateTimeStyle: .numeric, unitsStyle: .short)
  public static let numericAbbreviated = RelativeDateTimeFormatter(dateTimeStyle: .numeric, unitsStyle: .abbreviated)

  public static let namedFull = RelativeDateTimeFormatter(dateTimeStyle: .named, unitsStyle: .full)
  public static let namedSpellOut = RelativeDateTimeFormatter(dateTimeStyle: .named, unitsStyle: .spellOut)
  public static let namedShort = RelativeDateTimeFormatter(dateTimeStyle: .named, unitsStyle: .short)
  public static let namedAbbreviated = RelativeDateTimeFormatter(dateTimeStyle: .named, unitsStyle: .abbreviated)
}
