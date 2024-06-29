import Darwin

public extension FloatingPoint {
  var floor: Self {
    Darwin.floor(self)
  }

  var ceil: Self {
    Darwin.ceil(self)
  }

  var round: Self {
    Darwin.round(self)
  }
}
