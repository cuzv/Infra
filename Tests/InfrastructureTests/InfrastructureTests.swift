import XCTest
@testable import Infrastructure

final class InfrastructureTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let imageSize = CGSize(width: 200, height: 230)
        let imageRect = CGRect(origin: .zero, size: imageSize)
        
        let viewSize = CGSize(width: 60, height: 60)
        let viewRect = CGRect(origin: .zero, size: viewSize)
        
        print(imageSize.scaleAspectFill(to: viewSize))
        print(imageSize.scaleAspectFit(to: viewSize))
        
        print(imageRect.scaleAspectFill(to: viewRect).ceiled)
        print(imageRect.scaleAspectFit(to: viewRect).ceiled)
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}
