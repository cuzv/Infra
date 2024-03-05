import Foundation

public extension NumberFormatter {
  convenience init(
    numberStyle: Style,
    locale: Locale = .current,
    roundingMode: RoundingMode = .halfUp,
    minimumFractionDigits: Int = 0,
    maximumFractionDigits: Int = 2,
    minimumIntegerDigits: Int = 0,
    maximumIntegerDigits: Int = 42,
    minimumSignificantDigits: Int? = nil,
    maximumSignificantDigits: Int? = nil,
    usesSignificantDigits: Bool = false,
    positivePrefix: String? = nil
  ) {
    self.init()
    self.numberStyle = numberStyle
    self.locale = locale
    self.roundingMode = roundingMode
    self.minimumFractionDigits = minimumFractionDigits
    self.maximumFractionDigits = maximumFractionDigits
    self.minimumIntegerDigits = minimumIntegerDigits
    self.maximumIntegerDigits = maximumIntegerDigits
    if let digits = minimumSignificantDigits {
      self.minimumSignificantDigits = digits
    }
    if let digits = maximumSignificantDigits {
      self.maximumSignificantDigits = digits
    }
    self.usesSignificantDigits = usesSignificantDigits
    self.positivePrefix = positivePrefix
  }

  static let decimal = NumberFormatter(numberStyle: .decimal)
  static let percent = NumberFormatter(numberStyle: .percent)
  static let scientific = NumberFormatter(numberStyle: .scientific)
  static let ordinal = NumberFormatter(numberStyle: .ordinal)
  static let currency = NumberFormatter(numberStyle: .currency)
  static let currencyPlural = NumberFormatter(numberStyle: .currencyPlural)
}

public extension NumberFormatter {
  func stringify(_ value: Double) -> String {
    string(from: NSNumber(value: value)) ?? String(value)
  }

  func stringify(_ value: Float) -> String {
    string(from: NSNumber(value: value)) ?? String(value)
  }

  func stringify(_ value: Int) -> String {
    string(from: NSNumber(value: value)) ?? String(value)
  }

  func stringify(_ value: Int64) -> String {
    string(from: NSNumber(value: value)) ?? String(value)
  }
}
