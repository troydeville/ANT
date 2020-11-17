# ANT - Adapting Neural Topology

This implementation is a Neuralevolution (NE) type approach. 
  
NEAT stands for Neural Evolution of Augmenting Topologies. Just as our brain uses neurons to interpret information, this algorithm searches spaces minimally by creating new connections competitively until a solution is found.



- Add the package to your app.


**Use ANT inside your XCode project:**

- Create a ANT network.
```Swift
import ANT


let xor = ANT(1024)
xor.initializeEntities(structure: EntityStructure(inputs: 2, outputs: 1, inputActivation: .sigmoid, outputActivation: .sigmoid))
```

**Example:**
```Swift

let inputs: [[Float32]] = [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
let expOutput: [[Float32]] = [[0.0], [1.0], [1.0], [0.0]]

var highestScore: Float32 = 0

while true {
    
    for e in 0..<xor.entities.count {
        
        // Do test for entity
        var scoreTotal: Float32 = 0.0
        
        for i in 0..<inputs.count { // for each training value
            
            let result = xor.learn(entityIndex: e, input: inputs[i])
            
            for o in 0..<result.count {
                scoreTotal += abs(expOutput[i][o] - result[o])
            }
        }
        xor.appendCurrentEntityScore(entityIndex: e, pow(4 - scoreTotal, 2))

        if xor.entities[e].score > highestScore {
            xor.king = xor.entities[e]
            highestScore = xor.entities[e].score
        }
        
    }
    
    if highestScore >= (16 * 0.98) { break }

    xor.nextIteration()     // Next iteration of entities.
}

// Iterate test throught the king entity.
for i in 0..<inputs.count { print(xor.passThroughKing(input: inputs[i])) }

for c in xor.king!.network.connections {
    print("from: \(c.from), to: \(c.to), weight: \(c.weight) ")
}
for layer in xor.king!.network.layers {
    print("ID: \(layer.id), Nodes: \(layer.currentNodeIndex - 1), Activation: \(layer.activationFunction)")
}

```
