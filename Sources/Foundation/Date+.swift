import Foundation

public extension Date {
  func adding(component: Calendar.Component, value: Int) -> Date {
    if let date = Calendar.current.date(byAdding: component, value: value, to: self) {
      return date
    }

    let seconds: TimeInterval
    switch component {
    case .year:
      seconds = 60*60*24*365
    case .month:
      seconds = 60*60*24*30
    case .day:
      seconds = 60*60*24
    case .hour:
      seconds = 60*60
    case .minute:
      seconds = 60
    case .second:
      seconds = 1
    default:
      fatalError("Not Supported.")
    }
    return addingTimeInterval(seconds * TimeInterval(value))
  }

  mutating func add(component: Calendar.Component, value: Int) {
    self = adding(component: component, value: value)
  }

  var timeRemoved: Date {
    guard let date = Calendar.current.date(
      from: Calendar.current.dateComponents([.year, .month, .day], from: self)
    ) else {
      fatalError("Failed to strip time from Date object")
    }
    return date
  }

  var previousWeekday: Date {
    var previous = self
    let calendar = Calendar.current

    repeat {
      previous.add(component: .day, value: -1)
    } while calendar.isDateInWeekend(previous)

    return previous
  }
}
