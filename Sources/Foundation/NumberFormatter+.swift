import Foundation

extension NumberFormatter {
    public convenience init(
        numberStyle: Style,
        locale: Locale = .current,
        roundingMode: RoundingMode = .halfUp,
        maximumFractionDigits: Int = 0,
        maximumIntegerDigits: Int = 42,
        maximumSignificantDigits: Int = 6,
        usesSignificantDigits: Bool = false,
        positivePrefix: String? = nil
    ) {
        self.init()
        self.numberStyle = numberStyle
        self.locale = locale
        self.roundingMode = roundingMode
        self.maximumFractionDigits = maximumFractionDigits
        self.maximumIntegerDigits = maximumIntegerDigits
        self.maximumSignificantDigits = maximumSignificantDigits
        self.usesSignificantDigits = usesSignificantDigits
        self.positivePrefix = positivePrefix
    }

    public static let decimal = NumberFormatter(numberStyle: .decimal)
    public static let percent = NumberFormatter(numberStyle: .percent)
    public static let scientific = NumberFormatter(numberStyle: .scientific)
    public static let ordinal = NumberFormatter(numberStyle: .ordinal)
    public static let currency = NumberFormatter(numberStyle: .currency)
    public static let currencyPlural = NumberFormatter(numberStyle: .currencyPlural)
}

extension NumberFormatter {
    public func stringify(_ value: Double) -> String {
        string(from: NSNumber(value: value)) ?? String(value)
    }

    public func stringify(_ value: Float) -> String {
        string(from: NSNumber(value: value)) ?? String(value)
    }

    public func stringify(_ value: Int) -> String {
        string(from: NSNumber(value: value)) ?? String(value)
    }

    public func stringify(_ value: Int64) -> String {
        string(from: NSNumber(value: value)) ?? String(value)
    }
}
