public protocol Optionality {
    var isNil: Bool { get }
}

extension Optional: Optionality {
    public var isNil: Bool {
        self == nil
    }
}
