//
//  ProblemCases.swift
//  ANTTests
//
//  Created by Troy Deville on 4/3/23.
//

import XCTest
@testable import ANT

final class ProblemCases: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
    
    func testXORSingleThread() throws {
        var count = 0
        let iterationAmount = 1
        
        for _ in 1...iterationAmount {
//            print("\n------------------------------------\nXOR Test")
            let xor = ANT(512)
            let entityStructure = EntityStructure(inputs: 2, outputs: 1, inputActivation: ActivationFunction.add, outputActivation: ActivationFunction.add)
            xor.initializeEntities(structure: entityStructure)
            let xorInputData: [[Float]] = [[0,0], [0,1], [1,0], [1,1]]
            let xorExpectedOutput: [[Float]] = [[0], [1], [1], [0]]
            xor.train(input: xorInputData, expected: xorExpectedOutput, accuracy: 98)
            print(xor.entities[0].run(xorInputData))
            count += 1
            print("test completion: \(count) / \(iterationAmount)")
            print("\n------------------------------------")
            /*
             for c in xor.entities.first!.network.connections {
             print("from: \(c.from), to: \(c.to), weight: \(c.weight) ")
             }
             for layer in xor.entities.first!.network.layers {
             print(layer.activationFunction)
             }
             */
        }
    }
    
    func testXORMultithread() throws {
        let xorInputData: [[Float]] = [[0,0], [0,1], [1,0], [1,1]]
        let xorExpectedOutput: [[Float]] = [[0], [1], [1], [0]]
        
        
        let ant = ANT(512)
        ant.initializeEntities(structure: .init(inputs: 2, outputs: 1, inputActivation: .tanh, outputActivation: .tanh))
        ant.train(
            input: xorInputData,
            expected: xorExpectedOutput,
            accuracy: 98.0
        )
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
