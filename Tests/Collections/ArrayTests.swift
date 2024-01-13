import Foundation
@testable import Infrastructure
import XCTest

class ArrayTests: XCTestCase {
  func testSafeSwap() {
    var arr = [0, 1, 2, 3]

    arr.safeSwap(from: 1, to: 2)
    XCTAssertEqual(arr, [0, 2, 1, 3])

    arr.safeSwap(from: 0, to: 3)
    XCTAssertEqual(arr, [3, 2, 1, 0])
  }

  func testPrepend() {
    var arr = [Int]()

    arr.prepend(0)
    XCTAssertEqual(arr, [0])

    arr.prepend(1)
    XCTAssertEqual(arr, [1, 0])
  }

  func testSortByKeyPath() {
    var arr: [Person] = [
      .init(name: "A", age: 18),
      .init(name: nil, age: 20),
      .init(name: "C", age: 16),
    ]

    arr.sort(by: \.age)
    XCTAssertEqual(arr.map(\.age), [16, 18, 20])

    arr.reverse()
    XCTAssertEqual(arr.map(\.age), [16, 18, 20].reversed())

    arr.sort(by: \.name)
    XCTAssertEqual(arr.map(\.name), ["A", "C", nil])

    arr.reverse()
    XCTAssertEqual(arr.map(\.name), ["A", "C", nil].reversed())
  }

  func testRemove() {
    var arr = [0, 1, 2, 3, 4]

    XCTAssertEqual(arr.removeFirst(5), false)
    XCTAssertEqual(arr.removeFirst(4), true)
    XCTAssertEqual(arr.removeFirst(0), true)
    XCTAssertEqual(arr.removeFirst(2), true)
  }

  func testReplace() {
    var arr = [0, 1, 2, 3, 4]

    XCTAssertEqual(arr.replaceFirst(5, with: 6), false)
    XCTAssertEqual(arr.replaceFirst(4, with: 5), true)
  }

  func testRemoveAllHashable() {
    var arr: [Person] = [
      .init(name: "A", age: 18),
      .init(name: nil, age: 20),
      .init(name: "C", age: 16),
      .init(name: "A", age: 17),
    ]

    arr.removeAll(.init(name: "A", age: 19))
    XCTAssertEqual(arr.map(\.name), [nil, "C"])
  }

  func testRemoveDuplicates() {
    var arr1 = [0, 1, 1, 2, 2, 3]

    arr1.removeDuplicates()
    XCTAssertEqual(arr1, [0, 1, 2, 3])

    let arr2 = [0, 1, 1, 2, 2, 3]
    XCTAssertEqual(arr2.removingDuplicates(), [0, 1, 2, 3])
  }
}

private struct Person {
  let name: String?
  let age: Int
}

extension Person: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
}
