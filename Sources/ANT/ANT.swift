// Adapting Neural Topology
import Dispatch

public class ANT {
    
    let entityAmount: Int
    public var entities = [Entity]()
    
    var endScore: Float32 = 0.0
    var currentEntityWinners = [Entity]()
    
    var interations: Int = 0
    
    var currentEntityIndex = 0
    
    let group = DispatchGroup()
    
    var canLeaveSection = false
    
    public var king: Entity?
    
    public init(_ entityAmount: Int) {
        self.entityAmount = entityAmount
    }
    
    public func initializeEntities(structure: EntityStructure) {
        for i in 1...entityAmount {
            self.entities += [Entity(i, structure: structure)]
        }
    }
    
    public func train(input: [[Float32]], expected: [[Float32]], accuracy: Float32) {
        print("training . . .")
        
        // Split up entities into groups for multithreading
        var queues = [DispatchQueue]()
        
        let queueAmount = 16
        for q in 1...queueAmount {
            queues += [DispatchQueue(label: "adapting_calculation_\(q)")]
        }
        
        var queueEntityIndexes = [[Int]]()
        var ei = 0
        
        let modX = Float32(self.entityAmount) / Float32(queueAmount)
        
        while ei != self.entityAmount {
            var queueEntityPartIndexes = [Int]()
            
            if (ei % (Int(modX.rounded(.up))) == 0) {
                queueEntityPartIndexes += [ei]
                ei += 1
            }
            
            while ((ei % (Int(modX.rounded(.up))) != 0)) && (ei != self.entityAmount) {
                
                queueEntityPartIndexes += [ei]
                ei += 1
                
            }
            
            queueEntityIndexes += [queueEntityPartIndexes]
        }
        var lastScore: Float32 = 0.0
        var execute = 5
        while endScore < (accuracy) && self.interations < 100 && execute > 0 {
            lastScore = endScore
            var entitesThatAdapted_0 = [Entity]()
            var entitesThatAdapted_1 = [Entity]()
            var entitesThatAdapted_2 = [Entity]()
            var entitesThatAdapted_3 = [Entity]()
            var entitesThatAdapted_4 = [Entity]()
            var entitesThatAdapted_5 = [Entity]()
            var entitesThatAdapted_6 = [Entity]()
            var entitesThatAdapted_7 = [Entity]()
            var entitesThatAdapted_8 = [Entity]()
            var entitesThatAdapted_9 = [Entity]()
            var entitesThatAdapted_10 = [Entity]()
            var entitesThatAdapted_11 = [Entity]()
            var entitesThatAdapted_12 = [Entity]()
            var entitesThatAdapted_13 = [Entity]()
            var entitesThatAdapted_14 = [Entity]()
            var entitesThatAdapted_15 = [Entity]()
            
            for i in 0..<queueEntityIndexes.count {
                var entitiesToSend = [Entity]()
                for j in queueEntityIndexes[i] {
                    entitiesToSend += [self.entities[j]]
                }
                queues[i].async(group: group, qos: .userInitiated, flags: .enforceQoS) {
                    
                    switch i {
                    case 0:
                        entitesThatAdapted_0 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 1:
                        entitesThatAdapted_1 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 2:
                        entitesThatAdapted_2 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 3:
                        entitesThatAdapted_3 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 4:
                        entitesThatAdapted_4 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 5:
                        entitesThatAdapted_5 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 6:
                        entitesThatAdapted_6 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 7:
                        entitesThatAdapted_7 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 8:
                        entitesThatAdapted_8 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 9:
                        entitesThatAdapted_9 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 10:
                        entitesThatAdapted_10 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 11:
                        entitesThatAdapted_11 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 12:
                        entitesThatAdapted_12 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 13:
                        entitesThatAdapted_13 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 14:
                        entitesThatAdapted_14 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    case 15:
                        entitesThatAdapted_15 = self.adaptingCalculation(entities: entitiesToSend, input: input, expected: expected)
                    default: break   
                    }
                }
                
            }
            
            group.notify(queue: .global()) {
                
                
                self.canLeaveSection = true
            }
            
            while !canLeaveSection {}
            canLeaveSection = false
            
            var entityIndex = 0
            for i in 0...queueAmount - 1 {
                
                switch i {
                case 0:
                    for e in 0..<entitesThatAdapted_0.count {
                        self.entities[entityIndex] = entitesThatAdapted_0[e]
                        entityIndex += 1
                    }
                case 1:
                    for e in 0..<entitesThatAdapted_1.count {
                        self.entities[entityIndex] = entitesThatAdapted_1[e]
                        entityIndex += 1
                    }
                case 2:
                    for e in 0..<entitesThatAdapted_2.count {
                        self.entities[entityIndex] = entitesThatAdapted_2[e]
                        entityIndex += 1
                    }
                case 3:
                    for e in 0..<entitesThatAdapted_3.count {
                        self.entities[entityIndex] = entitesThatAdapted_3[e]
                        entityIndex += 1
                    }
                case 4:
                    for e in 0..<entitesThatAdapted_4.count {
                        self.entities[entityIndex] = entitesThatAdapted_4[e]
                        entityIndex += 1
                    }
                case 5:
                    for e in 0..<entitesThatAdapted_5.count {
                        self.entities[entityIndex] = entitesThatAdapted_5[e]
                        entityIndex += 1
                    }
                case 6:
                    for e in 0..<entitesThatAdapted_6.count {
                        self.entities[entityIndex] = entitesThatAdapted_6[e]
                        entityIndex += 1
                    }
                case 7:
                    for e in 0..<entitesThatAdapted_7.count {
                        self.entities[entityIndex] = entitesThatAdapted_7[e]
                        entityIndex += 1
                    }
                case 8:
                    for e in 0..<entitesThatAdapted_8.count {
                        self.entities[entityIndex] = entitesThatAdapted_8[e]
                        entityIndex += 1
                    }
                case 9:
                    for e in 0..<entitesThatAdapted_9.count {
                        self.entities[entityIndex] = entitesThatAdapted_9[e]
                        entityIndex += 1
                    }
                case 10:
                    for e in 0..<entitesThatAdapted_10.count {
                        self.entities[entityIndex] = entitesThatAdapted_10[e]
                        entityIndex += 1
                    }
                case 11:
                    for e in 0..<entitesThatAdapted_11.count {
                        self.entities[entityIndex] = entitesThatAdapted_11[e]
                        entityIndex += 1
                    }
                case 12:
                    for e in 0..<entitesThatAdapted_12.count {
                        self.entities[entityIndex] = entitesThatAdapted_12[e]
                        entityIndex += 1
                    }
                case 13:
                    for e in 0..<entitesThatAdapted_13.count {
                        self.entities[entityIndex] = entitesThatAdapted_13[e]
                        entityIndex += 1
                    }
                case 14:
                    for e in 0..<entitesThatAdapted_14.count {
                        self.entities[entityIndex] = entitesThatAdapted_14[e]
                        entityIndex += 1
                    }
                case 15:
                    for e in 0..<entitesThatAdapted_15.count {
                        self.entities[entityIndex] = entitesThatAdapted_15[e]
                        entityIndex += 1
                    }
                default: break
                    
                }
            }
            
            doANT()
            let learnStrength = abs(endScore - lastScore)
            if learnStrength < 0.01 && learnStrength > 0 {
                execute -= 1
            }
        }
        
        print("Generation: \(self.interations)")
        print("Best performer's node count: \(self.entities[0].getNodeCount())")
        print("Best performer's connection count: \(self.entities[0].getConnectionCount())")
    }
    
    private func doANT() {
        // Sort the entities by score.
        self.entities.sort()
        
        //let storePercent = 0.6 - (exp(0.0038 * endScore) - 1)
        //let storePercent = 0.7 - (exp(0.0050 * endScore) - 1)
        let storePercent: Float32 = 0.1
        
        // Store top performing entities.
        if currentEntityWinners.isEmpty {
            for i in 0..<(Int(Float32(self.entityAmount) * storePercent)) {
                currentEntityWinners += [self.entities[i]]
            }
        } else {
            for i in 0..<(Int(Float32(self.entityAmount) * storePercent)) {
                
                if currentEntityWinners[i].score <= self.entities[i].score {
                    currentEntityWinners[i] = self.entities[i]
                }
 
                //currentEntityWinners[i] = self.entities[i]
            }
        }
        
        // Remove lower performing
        self.entities.removeAll()
        for e in currentEntityWinners {
            self.entities += [e]
        }
        
        // Replace with copies of top performing entities.
        for _ in 1...(self.entityAmount - self.entities.count) {
            let randomEntityWinnerIndex = Int.random(in: 0..<(Int(Float32(self.entityAmount) * storePercent)))
            //let randomEntityWinnerIndex = Int.random(in: 0...29)
            self.entities += [currentEntityWinners[randomEntityWinnerIndex]]
        }
        
        endScore = self.entities[0].score
        //print("\u{001B}[2J", terminator: "Highest Score: \(endScore)%\n")
        self.interations += 1
        print("\u{1B}[1A\u{1B}[KGeneration: \(self.interations), Score: \(endScore)")
    }
    
    private func adaptingCalculation(entities: [Entity], input: [[Float32]], expected: [[Float32]]) -> [Entity] {
        group.enter()
        
        
        var entitiesToAlter = entities
        
        for entityIndex in 0..<entitiesToAlter.count {
            // Alter entity
            entitiesToAlter[entityIndex].alter()
            
            
            // Get output
            let output = entitiesToAlter[entityIndex].run(input)
            
            var score: Float32 = 0.0
            //var totalExpected: Float32 = 0.0
            
            for o1 in 0..<expected.count {
                
                for o2 in 0..<expected[o1].count {
                    
                    score += 1 - abs(expected[o1][o2] - output[o1][o2])
                    
                    /*
                    //score += abs(expected[o1][o2] - output[o1][o2])
                    score += (expected[o1][o2] - abs(expected[o1][o2] - output[o1][o2]))
                    totalExpected += expected[o1][o2]
                    */
                }
                
            }
            /*
            //print("Score: \(score)/\(totalExpected)")
            //print("Total expected: \(totalExpected)")
            //score = (Float32(expected.count * expected.first!.count) - score) / Float32(expected.count * expected.first!.count) * 100
            score = (1 + (score / totalExpected)) / 2 * 100
            */
            
            score = score / (Float32(expected.count) * Float32(expected[0].count))
            
            entitiesToAlter[entityIndex].score = score * 100
        }
        
        group.leave()
        return entitiesToAlter
    }
    
    func run(input: [[Float32]]) -> [[Float32]] {
        if self.entities.count != 0 {
            return self.entities[0].run(input)
        }
        return [[Float32]]()
    }
    
    /* CONTINUOUS NAAC */
    // 1. a
    public func alterEntity() {
        self.entities[currentEntityIndex].alter()
    }
    
    // 1. b
    public func alterEntity(entityIndex: Int) {
        self.entities[entityIndex].alter()
    }
    
    // 2.a
    public func learn(input: [Float32]) -> [Float32] {
        return self.entities[currentEntityIndex].run(input)
    }
    
    // 2.b
    public func learn(entityIndex: Int, input: [Float32]) -> [Float32] {
        return self.entities[entityIndex].run(input)
    }
    
    public func passThroughKing(input: [Float32]) -> [Float32] {
        return self.king!.run(input)
    }
    
    // 3.a
    public func appendCurrentEntityScore(_ score: Float32) {
        self.entities[currentEntityIndex].score = self.entities[currentEntityIndex].score + score
    }
    
    // 3.b
    public func appendCurrentEntityScore(entityIndex: Int, _ score: Float32) {
        self.entities[entityIndex].score = score
    }
    
    public func nextIteration() {
        for e in 0..<self.entities.count {
            alterEntity(entityIndex: e)
        }
        doANT()
    }
    
    public func nextEntity() {
        if self.currentEntityIndex < self.entityAmount - 1 {
            self.currentEntityIndex += 1
        } else {
            doANT()
            self.currentEntityIndex = 0
        }
    }

}
