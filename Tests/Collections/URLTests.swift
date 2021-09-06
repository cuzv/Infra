import Foundation
import XCTest
@testable import Infrastructure

class URLTests: XCTestCase {
    func testQueryItems1() {
        var url: URL = "https://google.com"
        url.appendQueryItems([
            .init(name: "page", value: "1"),
            .init(name: "size", value: "20"),
        ])
        XCTAssertEqual(url.absoluteString, "https://google.com?page=1&size=20")
    }

    func testQueryItems2() {
        var url: URL = "https://google.com"
        url.appendQueryItems([
            .init(name: "arr", value: "1"),
            .init(name: "arr", value: "2"),
        ])
        print(url.absoluteString)
        XCTAssertEqual(url.absoluteString, "https://google.com?arr=1&arr=2")
        XCTAssertEqual(url.queryValue(for: "arr"), ["1", "2"])
    }

    func testQueryItems3(){
        var url: URL = "https://google.com?arr=1&arr=2"
        url.deleteQueryItems()
        XCTAssertEqual(url.absoluteString, "https://google.com")
    }

    func testQueryItems4(){
        var url: URL = "https://google.com?arr=1&arr=2"
        url.queryItems = []
        XCTAssertEqual(url.absoluteString, "https://google.com")
    }
}
