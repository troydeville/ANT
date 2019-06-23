import XCTest
@testable import ANT

final class ANTTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ANT().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
