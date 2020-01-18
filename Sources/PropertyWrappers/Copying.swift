import Foundation

/// Many Cocoa classes implement value-like objects that require explicit copying. Swift currently provides an @NSCopying attribute for properties to give them behavior like Objective-C's @property(copy), invoking the copy method on new objects when the property is set. We can turn this into a wrapper.
@propertyWrapper
public struct Copying<Value: NSCopying> {
    private var value: Value

    public init(wrappedValue value: Value) {
        // Copy the value on initialization.
        self.value = value.copy() as! Value
    }

    public var wrappedValue: Value {
        get { return value }
        set {
            // Copy the value on reassignment.
            value = newValue.copy() as! Value
        }
    }
}
