import Foundation

@discardableResult
func swizzleMethod(
  ofClass clazz: AnyClass,
  original originalSelector: Selector,
  override overrideSelector: Selector,
  isInstanceMethod: Bool
) -> Bool {
  if
    let originalMethod = class_getInstanceMethod(clazz, originalSelector),
    let overrideMethod = class_getInstanceMethod(clazz, overrideSelector)
  {
    if isInstanceMethod, class_addMethod(
      clazz,
      originalSelector,
      method_getImplementation(overrideMethod),
      method_getTypeEncoding(overrideMethod)
    ) {
      class_replaceMethod(
        clazz,
        overrideSelector,
        method_getImplementation(originalMethod),
        method_getTypeEncoding(originalMethod)
      )
    } else {
      method_exchangeImplementations(originalMethod, overrideMethod)
    }
    return true
  }
  return false
}

@discardableResult
public func swizzleClassMethod(
  ofClass clazz: AnyClass,
  original originalSelector: Selector,
  override overrideSelector: Selector
) -> Bool {
  swizzleMethod(
    ofClass: clazz,
    original: originalSelector,
    override: overrideSelector,
    isInstanceMethod: false
  )
}

@discardableResult
public func swizzleInstanceMethod(
  ofClass clazz: AnyClass,
  original originalSelector: Selector,
  override overrideSelector: Selector
) -> Bool {
  swizzleMethod(
    ofClass: clazz,
    original: originalSelector,
    override: overrideSelector,
    isInstanceMethod: true
  )
}
