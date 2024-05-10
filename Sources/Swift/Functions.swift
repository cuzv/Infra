import Foundation

public func equal<T: Equatable>(_ lhs: T, _ rhs: T) -> Bool {
  lhs == rhs
}

public func and(_ lhs: Bool, _ rhs: Bool) -> Bool {
  lhs && rhs
}

public func or(_ lhs: Bool, _ rhs: Bool) -> Bool {
  lhs || rhs
}

public func tuple<L, R>(_ lhs: L, _ rhs: R) -> (L, R) {
  (lhs, rhs)
}
