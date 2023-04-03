import XCTest
@testable import ANT

final class ANTTests: XCTestCase {
    
    func testBase() throws {
        
        let populationSize = 512
        
        let ant = ANT(populationSize)
        
        XCTAssert(ant.entityAmount == populationSize)
        
    }

    static var allTests = [
        ("testBase", testBase),
    ]
}
