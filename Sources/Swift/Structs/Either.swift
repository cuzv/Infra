import Foundation

public enum Either<Left, Right> {
  case left(Left)
  case right(Right)

  public static func isLeft(_ item: Either<Left, Right>) -> Bool {
    !isRight(item)
  }

  public static func isRight(_ item: Either<Left, Right>) -> Bool {
    if case .right = item { return true }
    return false
  }

  public var left: Left? {
    switch self {
    case let .left(value): value
    default: nil
    }
  }

  public var right: Right? {
    switch self {
    case let .right(value): value
    default: nil
    }
  }

  public func map<NewRight>(
    _ f: (Right) -> NewRight
  ) -> Either<Left, NewRight> {
    switch self {
    case let .right(value): .right(f(value))
    case let .left(value): .left(value)
    }
  }

  public func flatMap<NewRight>(
    _ f: (Right) -> Either<Left, NewRight>
  ) -> Either<Left, NewRight> {
    switch self {
    case let .right(value): f(value)
    case let .left(value): .left(value)
    }
  }
}
