//
//  Network.swift
//  NAAC
//
//  Created by Troy Deville on 11/16/18.
//

struct Network {
    
    var layers = [Layer]()
    var connections = [NetworkPacket]()
    var currentLayerIndex = 1
    
    init(structure: EntityStructure) {
        let inputLayer = Layer(type: .input, id: -1, nodeAmount: structure.inputs, activation: structure.inputActivation)
        let outputLayer = Layer(type: .output, id: 0, nodeAmount: structure.outputs, activation: structure.outputActivation)
        self.layers += [inputLayer, outputLayer]
        
    }
    
    mutating func compute(_ x: [Float32]) -> [Float32] {
        var output = [Float32]()
        
        // Set input layer nodes value
        for nodeId in 0..<self.layers[0].nodes.count {
            self.layers[0].nodes[nodeId].value = x[nodeId]
        }
        
        for connection in connections {
            
            let from = connection.from
            let to = connection.to
            
            var fromLayerIdToUse = from.layerId
            var toLayerIdToUse = to.layerId
            if from.layerId == -1 {
                fromLayerIdToUse = 0
            }
            if to.layerId == 0 {
                toLayerIdToUse = self.currentLayerIndex
            }
            
            // Get from's output value
            let fromValue = self.layers[fromLayerIdToUse].nodes[from.nodeId - 1].value
            let fromValueFromActivation = self.layers[fromLayerIdToUse].nodes[from.nodeId - 1].activation.passValue(fromValue)
            // Append from's output value to to's value.
            self.layers[toLayerIdToUse].nodes[to.nodeId - 1].value += fromValueFromActivation * connection.weight
        }
        
        let outputLayer = self.layers[currentLayerIndex]
        
        
        for node in 0..<outputLayer.nodes.count {
            let currentNodeOutput = self.layers[currentLayerIndex].nodes[node].value
            let activationOutput = self.layers[currentLayerIndex].nodes[node].activation.passValue(currentNodeOutput)
            self.layers[currentLayerIndex].nodes[node].value = activationOutput
            output += [activationOutput]
        }
        
        
        // Reset all node values.
        for layerId in 0..<self.layers.count {
            self.layers[layerId].resetNodeValues()
        }
        
        return output
    }
    
    mutating func compute(_ x: [[Float32]]) -> [[Float32]] {
        
        var output = [[Float32]]()
        
        for value in x {
            
            // Set input layer nodes value
            for nodeId in 0..<self.layers[0].nodes.count {
                self.layers[0].nodes[nodeId].value = value[nodeId]
            }
            
            for connection in connections {
                
                let from = connection.from
                let to = connection.to
                
                var fromLayerIdToUse = from.layerId
                var toLayerIdToUse = to.layerId
                if from.layerId == -1 {
                    fromLayerIdToUse = 0
                }
                if to.layerId == 0 {
                    toLayerIdToUse = self.currentLayerIndex
                }
                
                // Get from's output value
                let fromValue = self.layers[fromLayerIdToUse].nodes[from.nodeId - 1].value
                let fromValueFromActivation = self.layers[fromLayerIdToUse].nodes[from.nodeId - 1].activation.passValue(fromValue)
                // Append from's output value to to's value.
                self.layers[toLayerIdToUse].nodes[to.nodeId - 1].value += fromValueFromActivation * connection.weight
            }
            
            let outputLayer = self.layers[currentLayerIndex]
            
            var outputNodeValues = [Float32]()
            
            for node in 0..<outputLayer.nodes.count {
                let currentNodeOutput = self.layers[currentLayerIndex].nodes[node].value
                let activationOutput = self.layers[currentLayerIndex].nodes[node].activation.passValue(currentNodeOutput)
                self.layers[currentLayerIndex].nodes[node].value = activationOutput
                outputNodeValues += [activationOutput]
            }
            
            output += [outputNodeValues]

            // Reset all node values.
            for layerId in 0..<self.layers.count {
                self.layers[layerId].resetNodeValues()
            }
        }

        return output
    }
    
    mutating func addLayer() {
        var newLayer = Layer(type: LayerType.hidden, id: self.currentLayerIndex, activation: RandomActivationFunction())
        self.currentLayerIndex += 1
        newLayer.addNode()
        
        self.layers += [newLayer]
        self.layers.sort()
    }
    
    mutating func addConnection(_ from: NetworkAddress, _ to: NetworkAddress) {
        
        /* Check if connection exists */
        
        // Create potentially new connection.
        let newConnection = NetworkPacket(from, to)
        //print("Create potentially new connection.")
        //print(newConnection)
        
        // Determine if connection exists in this network.
        if self.connections.contains(newConnection) {
            
            // Connection exists, so return void.
            //print("Connection Exists, so exit.")
            return
            
        } else { /* Connection does not exist. */
            //print("Connection does not Exist.")
            // Determine if connection is valid for this network.
            if (from.layerId > 0 || from.layerId < 0) && (to.layerId != -1) && ((to.layerId >= from.layerId) || (from.layerId == currentLayerIndex - 1 && to.layerId == 0)) {
                if (from.layerId == to.layerId) && (from.nodeId != to.nodeId) {
                    //print("Connection not valid.")
                    return
                }
                //print("connection is valid for this network.")
                // Is a valid connection. Determine if layers and nodes exist in this network to support connection.
                if (from.layerId == -1 || from.layerId < self.currentLayerIndex) &&
                    (to.layerId == 0 || to.layerId < self.currentLayerIndex)
                    
                { // Layers exist in this network, check if nodes exist in the layer.
                    //print("Layers exist in this network")
                    var fromLayerIdToUse = from.layerId
                    var toLayerIdToUse = to.layerId
                    if from.layerId == -1 {
                        fromLayerIdToUse = 0
                    } else if to.layerId == 0 {
                        toLayerIdToUse = self.currentLayerIndex
                    }
                    if (self.layers[fromLayerIdToUse].nodes.contains(Node(id: from.nodeId))) &&
                        (self.layers[toLayerIdToUse].nodes.contains(Node(id: to.nodeId)))
                    {
                        //print("Nodes exist in the layers of this network and connection was added.")
                        // Nodes exist in the layers of this network. Can add the new connection.
                        self.connections += [newConnection]
                        self.connections.sort()
                        
                    } else {
                        //print("The connection wasn't added; nodes don't exist in the layers of this network")
                    }
                    
                }
                
            } else {
                //print("Invalid connection.")
            }
            
        }
        
    } // end
    
}


/* Routing */

struct NetworkPacket {
    var from: NetworkAddress
    var to: NetworkAddress
    var weight = Float32.random(in: -1.0...1.0)
    
    init(_ from: NetworkAddress, _ to: NetworkAddress) {
        self.from = from
        self.to = to
    }
    
    mutating func alterWeight(_ byAmount: Float32) {
        self.weight += byAmount
    }
    
}

extension NetworkPacket: Comparable {
    
    static func < (lhs: NetworkPacket, rhs: NetworkPacket) -> Bool {
        return lhs.from < rhs.from
    }
    
    static func == (lhs: NetworkPacket, rhs: NetworkPacket) -> Bool {
        return (lhs.from == rhs.from) && (lhs.to == rhs.to)
    }
    
}

struct NetworkAddress {
    let layerId: Int
    let nodeId: Int
    
    init(_ layerId: Int, _ nodeId: Int) {
        self.layerId = layerId
        self.nodeId = nodeId
    }
    
}

extension NetworkAddress: Comparable {
    
    static func < (lhs: NetworkAddress, rhs: NetworkAddress) -> Bool {
        if (lhs.layerId == rhs.layerId) {
            if lhs.nodeId == rhs.nodeId {
                return lhs.nodeId > rhs.nodeId
            }
            return lhs.nodeId > rhs.nodeId
        }
        return lhs.layerId < rhs.layerId
    }
    
    static func == (lhs: NetworkAddress, rhs: NetworkAddress) -> Bool {
        return (lhs.layerId == rhs.layerId) && (lhs.nodeId == rhs.nodeId)
    }
    
}
