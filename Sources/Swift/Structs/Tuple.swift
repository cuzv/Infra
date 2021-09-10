// MARK: - Tuple

public struct Tuple<Left, Right> {
  public let left: Left
  public let right: Right

  public init(left: Left, right: Right) {
    self.left = left
    self.right = right
  }

  public var tupleValue: (Left, Right) {
    (left, right)
  }
}

extension Tuple: Codable where Left: Codable, Right: Codable {
  enum CodingKeys: String, CodingKey {
    case left, right
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    left = try container.decode(Left.self, forKey: .left)
    right = try container.decode(Right.self, forKey: .right)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(left, forKey: .left)
    try container.encode(right, forKey: .right)
  }
}

extension Tuple: Equatable where Left: Equatable, Right: Equatable {
  public static func == (lhs: Tuple, rhs: Tuple) -> Bool {
    lhs.left == rhs.left && lhs.right == rhs.right
  }
}

// MARK: - Tuple3

public struct Tuple3<Left, Center, Right> {
  public let left: Left
  public let center: Center
  public let right: Right

  public init(left: Left, center: Center, right: Right) {
    self.left = left
    self.center = center
    self.right = right
  }

  public var tupleValue: (Left, Center, Right) {
    (left, center, right)
  }
}

extension Tuple3: Codable where Left: Codable, Center: Codable, Right: Codable {
  enum CodingKeys: String, CodingKey {
    case left, center, right
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    left = try container.decode(Left.self, forKey: .left)
    center = try container.decode(Center.self, forKey: .center)
    right = try container.decode(Right.self, forKey: .right)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(left, forKey: .left)
    try container.encode(center, forKey: .center)
    try container.encode(right, forKey: .right)
  }
}

extension Tuple3: Equatable
where
  Left: Equatable,
  Center: Equatable,
  Right: Equatable
{
  public static func == (lhs: Tuple3, rhs: Tuple3) -> Bool {
    lhs.left == rhs.left && lhs.center == rhs.center && lhs.right == rhs.right
  }
}
