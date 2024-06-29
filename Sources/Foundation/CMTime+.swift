//  Created by Shaw on 2/24/22.

import AVFoundation

public extension CMTime {
  private static let formatter: DateFormatter = {
    let retval = DateFormatter()
    retval.timeZone = .current
    retval.locale = .current
    return retval
  }()

  func formattedString(includeMilliseconds: Bool = true) -> String {
    if isNumeric {
      let hrs = seconds >= 3600 ? "HH:" : ""
      let msecs = includeMilliseconds ? ".SSS" : ""
      let format = "\(hrs)mm:ss\(msecs)"

      CMTime.formatter.setLocalizedDateFormatFromTemplate(format)
      let retval = CMTime.formatter.string(from: .init(timeIntervalSince1970: seconds))

      return retval
    } else {
      return "n/a"
    }
  }

  static func clamped(duration: CMTime, multiplier: Float64) -> CMTime {
    let time = CMTimeMultiplyByFloat64(duration, multiplier: multiplier)
    let dest = max(.zero, min(duration, time))
    return dest
  }
}
