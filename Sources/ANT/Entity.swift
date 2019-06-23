//
//  Entity.swift
//  NAAC
//
//  Created by Troy Deville on 11/16/18.
//

import Darwin

public struct Entity {
    
    private let id: Int
    var network: Network
    var score: Float32 = 0.0
    private let structure: EntityStructure
    let maxHeight = 1024
    let maxDepth = 1024
    
    public init(_ id: Int, structure: EntityStructure) {
        self.id = id
        self.structure = structure
        self.network = Network(structure: self.structure)
    }
    
    /* Getters */
    func getId() -> Int { return self.id }
    
    func getNodeCount() -> Int {
        var sum = 0
        for layer in self.network.layers {
            sum += layer.nodes.count
        }
        return sum
    }
    
    func getConnectionCount() -> Int {
        return self.network.connections.count
    }
    
    /* Setters */
    
    /* Functions */
    public mutating func run(_ input: [[Float32]]) -> [[Float32]] {
        
        return network.compute(input)
    }
    
    public mutating func run(_ input: [Float32]) -> [Float32] {
        return network.compute(input)
    }
    
    mutating func alter() {
        if Float32.random(in: 0...100) <= 80 {
            
            if Float32.random(in: 0...100) <= 5 {
                alterRandomNetworkWeight()
            }
            for _ in 1...1 {
                alterRandomNetworkWeight(0.5 * Float32.random(in: -1...1))
            }
            
        }
        // Original 80, 2, 10, 25
        //2,2,5,25
        //80,1,1,25?
        
        if Float32.random(in: 0...100) <= 30 {
            addRandomConnection()
        }
        
        if Float32.random(in: 0...100) <= 8 {
            if Float32.random(in: 0...100) <= 30 {
                addRandomNode()
            } else {
                addNewLayer()
            }
        }
        
        if Float32.random(in: 0...100) <= 35 {
            alterRandomNetworkActivation()
        }
        
    }
    
    mutating func addRandomConnection() {
        
        // find a random layer and random node in layer
        
        let fromLayerIndex = Int.random(in: 0..<self.network.layers.count - 1)
        let toLayerIndex = Int.random(in: 1..<self.network.layers.count)
        let fromNodeIndex = Int.random(in: 0..<self.network.layers[fromLayerIndex].nodes.count)
        let toNodeIndex = Int.random(in: 0..<self.network.layers[toLayerIndex].nodes.count)
        
        var fL: Int
        if fromLayerIndex == 0 {
            fL = -1
        } else if fromLayerIndex == self.network.currentLayerIndex {
            fL = 0
        } else {
            fL = fromLayerIndex
        }
        
        var tL: Int
        if toLayerIndex == 0 {
            tL = -1
        } else if toLayerIndex == self.network.currentLayerIndex {
            tL = 0
        } else {
            tL = toLayerIndex
        }
        
        let fromNodeId = self.network.layers[fromLayerIndex].nodes[fromNodeIndex].id
        let toNodeId = self.network.layers[toLayerIndex].nodes[toNodeIndex].id
        
        let from = NetworkAddress(fL, fromNodeId)
        let to = NetworkAddress(tL, toNodeId)
        /*
         if from.nodeId == to.nodeId {
         return
         }
         */
        self.network.addConnection(from, to)
    }
    
    mutating func addRandomNode() {
        
        // New nodes are put in an existing hidden layer.
        // Create two new random connections coming from random nodes in the previous layer and going to the layer ahead.
        var randomLayerIndex: Int
        if self.network.layers.count > 2 {
            randomLayerIndex = Int.random(in: 1..<self.network.layers.count - 1)
            if self.network.layers[randomLayerIndex].currentNodeIndex > self.maxHeight { return }
            self.network.layers[randomLayerIndex].addNode()
            
            let fromNodeIndex = Int.random(in: 0..<self.network.layers[randomLayerIndex - 1].nodes.count)
            let toNodeIndex = Int.random(in: 0..<self.network.layers[randomLayerIndex + 1].nodes.count)
            let newNodeId = self.network.layers[randomLayerIndex].nodes.last!.id
            
            let fromNodeId = self.network.layers[randomLayerIndex - 1].nodes[fromNodeIndex].id
            let toNodeId = self.network.layers[randomLayerIndex + 1].nodes[toNodeIndex].id
            
            let fromLayerId = self.network.layers[randomLayerIndex - 1].id
            let toLayerId = self.network.layers[randomLayerIndex + 1].id
            
            let from = NetworkAddress(fromLayerId, fromNodeId)
            let newNode = NetworkAddress(randomLayerIndex, newNodeId)
            let to = NetworkAddress(toLayerId, toNodeId)
            
            self.network.addConnection(from, newNode)
            self.network.addConnection(newNode, to)
            
        } else {
            addNewLayer()
        }
        
    }
    
    mutating func addNewLayer() {
        
        // If current layer count is eight, return
        if self.network.currentLayerIndex > self.maxDepth { return }
        
        // One new layer is created, a node in the layer is also created.
        // Therefore, add a random connection from previous layer's node and to ahead layer's node.
        self.network.addLayer()
        
        let newLayerIndex = self.network.currentLayerIndex - 1
        
        let fromNodeIndex = Int.random(in: 0..<self.network.layers[newLayerIndex - 1].nodes.count)
        let toNodeIndex = Int.random(in: 0..<self.network.layers[newLayerIndex + 1].nodes.count)
        //let newNodeIndex = self.network.layers[newLayerIndex].nodes.last!.id
        
        let fromNodeId = self.network.layers[newLayerIndex - 1].nodes[fromNodeIndex].id
        let toNodeId = self.network.layers[newLayerIndex + 1].nodes[toNodeIndex].id
        let newLayerId = self.network.layers[newLayerIndex].id
        let fromLayerId = self.network.layers[newLayerIndex - 1].id
        let toLayerId = self.network.layers[newLayerIndex + 1].id
        
        
        let from = NetworkAddress(fromLayerId, fromNodeId)
        let newNode = NetworkAddress(newLayerId, 1)
        let to = NetworkAddress(toLayerId, toNodeId)
        
        self.network.addConnection(from, newNode)
        self.network.addConnection(newNode, to)
        
    }
    
    mutating func alterRandomNetworkWeight(_ byAmount: Float32) {
        // Get random connection index
        if !self.network.connections.isEmpty {
            let randConnectionIndex = Int.random(in: 0..<self.network.connections.count)
            self.network.connections[randConnectionIndex].alterWeight(byAmount)
        }
        
    }
    
    mutating func alterRandomNetworkWeight() {
        // Get random connection index
        if !self.network.connections.isEmpty {
            let randConnectionIndex = Int.random(in: 0..<self.network.connections.count)
            self.network.connections[randConnectionIndex].weight = Float32.random(in: -1...1)
        }
        
    }
    
    mutating func alterRandomNetworkActivation() {
        // Get random connection index
        if !self.network.layers.isEmpty && self.network.layers.count > 2 {
            let randLayerIndex = Int.random(in: 1..<self.network.layers.count - 1)
            let randNodeIndex = Int.random(in: 0..<self.network.layers[randLayerIndex].nodes.count)
            self.network.layers[randLayerIndex].nodes[randNodeIndex].setActivationFunction(function: RandomActivationFunction())
        }
    }
    
}

public struct EntityStructure {
    
    let inputs: Int
    let outputs: Int
    let inputActivation: ActivationFunction
    let outputActivation: ActivationFunction
    
    public init(inputs: Int, outputs: Int, inputActivation: ActivationFunction, outputActivation: ActivationFunction){
        self.inputs = inputs
        self.outputs = outputs
        self.inputActivation = inputActivation
        self.outputActivation = outputActivation
    }
}

extension Entity: Comparable {
    public static func < (lhs: Entity, rhs: Entity) -> Bool {
        return lhs.score > rhs.score
    }
    
    public static func == (lhs: Entity, rhs: Entity) -> Bool {
        return lhs.score == rhs.score
    }
    
    
}
