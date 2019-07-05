import XCTest
@testable import ANT

final class ANTTests: XCTestCase {
    func testExample() {
        var count = 0
        let iterationAmount = 1
        
        for _ in 1...iterationAmount {
            print("\n------------------------------------\nXOR Test")
            let xor = ANT(512)
            let entityStructure = EntityStructure(inputs: 2, outputs: 1, inputActivation: ActivationFunction.add, outputActivation: ActivationFunction.add)
            xor.initializeEntities(structure: entityStructure)
            let xorInputData: [[Float]] = [[0,0], [0,1], [1,0], [1,1]]
            let xorExpectedOutput: [[Float]] = [[0], [1], [1], [0]]
            xor.train(input: xorInputData, expected: xorExpectedOutput, accuracy: 99)
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

    static var allTests = [
        ("testExample", testExample),
    ]
}
