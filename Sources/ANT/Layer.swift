//
//  Layer.swift
//  NAAC
//
//  Created by Troy Deville on 11/16/18.
//

struct Layer {
    
    var nodes = [Node]()
    let type: LayerType
    let id: Int
    var currentNodeIndex = 1
    var activationFunction: ActivationFunction
    
    init(type: LayerType, id: Int, activation: ActivationFunction) {
        self.type = type
        self.id = id
        self.activationFunction = activation
    }
    
    init(type: LayerType, id: Int, nodeAmount: Int, activation: ActivationFunction) {
        self.type = type
        self.id = id
        for _ in 1...nodeAmount {
            self.nodes += [Node(id: self.currentNodeIndex, activation)]
            self.currentNodeIndex += 1
        }
        self.activationFunction = activation
    }
    
    mutating func addNode() {
        let newNode = Node(id: currentNodeIndex, RandomActivationFunction())
        self.currentNodeIndex += 1
        self.nodes += [newNode]
        self.nodes.sort()
    }
    
    mutating func resetNodeValues() {
        for nodeId in 0..<nodes.count {
            self.nodes[nodeId].value = 0.0
        }
    }
    
}

extension Layer: Comparable {
    static func < (lhs: Layer, rhs: Layer) -> Bool {
        if (lhs.id == 0 && rhs.id > 0) || (lhs.id > 0 && rhs.id == 0) {
            //print("lhs = 0, rhs > 0")
            return lhs.id > rhs.id
        }
        //print("else")
        return lhs.id < rhs.id
    }
    
    static func == (lhs: Layer, rhs: Layer) -> Bool {
        return lhs.id == rhs.id
    }
}

enum LayerType {
    case input
    case hidden
    case output
}
