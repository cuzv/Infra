import Foundation

extension NSMutableAttributedString {
  public func replaceCharacters(of target: String, with replacement: String) {
    if let range = string.range(of: target) {
      let nsrange = NSRange(range, in: string)
      replaceCharacters(in: nsrange, with: replacement)
    } else {
      print("*** replace target `\(target)` not found.")
    }
  }

  public func replaceCharacters(of target: String, with replacement: NSAttributedString) {
    if let range = string.range(of: target) {
      let nsrange = NSRange(range, in: string)
      replaceCharacters(in: nsrange, with: replacement)
    } else {
      print("*** replace target `\(target)` not found.")
    }
  }
}

#if canImport(UIKit)
import UIKit
extension NSAttributedString {
  public func layoutSize(withConstrainedWidth width: CGFloat) -> CGSize {
    let size = CGSize(width: width, height: .greatestFiniteMagnitude)
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine]
    return boundingRect(with: size, options: options, context: nil).size
  }
}
#endif
