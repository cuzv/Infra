import Foundation

extension Extnsion where Base: AnyObject {
    public func setTo<Value>(
        _ keyPath: ReferenceWritableKeyPath<Base, Value>
    ) -> (Value) -> Void {
        { [weak base] value in
            base?[keyPath: keyPath] = value
        }
    }
}
