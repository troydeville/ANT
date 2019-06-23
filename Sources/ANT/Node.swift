//
//  Node.swift
//  NAAC
//
//  Created by Troy Deville on 11/16/18.
//

import Foundation

struct Node {
    
    let id: Int
    var activation: Activation
    var value: Float32 = 0.0
    
    init(id: Int, _ activationFunction: ActivationFunction) {
        self.id = id
        self.activation = Activation(activationFunction)
    }
    
    // Initializer for comparison purposes.
    init (id: Int) {
        self.id = id
        self.activation = Activation(ActivationFunction.sigmoid)
    }
    
    mutating func setActivation(_ activation: Activation) {
        self.activation = activation
    }
    
    mutating func setActivationFunction(function: ActivationFunction) {
        self.activation.activationFunction = function
    }
    
}

extension Node: Comparable {
    
    static func < (lhs: Node, rhs: Node) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
    
}

struct Activation {
    
    var activationFunction: ActivationFunction
    
    init(_ activationFunction: ActivationFunction) {
        self.activationFunction = activationFunction
    }
    
    /*
     func passValue(_ x: Float32) -> Float32 {
     if x < 0.0 {
     return 0.0
     }
     return x
     }
     */
    
    func passValue(_ x: Float32) -> Float32 {
        
        // was 5
        let precision: Float32 =  1
        let scale: Float32 = 1
        
        switch activationFunction {
        case .add:
            return x
        case .sigmoid:
            return (precision / (1 + exp(-scale * x)))
        case .tanh:
            return tanh(x*scale) * precision
        case .relu:
            if x < 0.0 {
                return 0.0
            }
            return x
        case .sine:
            return sin(x*scale) * precision
        case .abs:
            return abs(x)
        case .square:
            return x * x
        case .cube:
            return x * x * x
        case .gauss:
            return (precision / sqrt(2 * Float32.pi)) * exp(-scale * x * x)
        case .clamped:
            if x < -1 {
                return -1
            } else if x > 1 {
                return 1
            }
            return x
        case .hat:
            if (x < -1) || (x > 1) {
                return 0
            }
            return x
        case .sinh:
            return sinh(x * scale) * precision
        case .sech:
            return precision / cosh(x * scale)
        }
    }
    
}

public enum ActivationFunction {
    case add
    case sigmoid
    case tanh
    case relu
    case sine
    case abs
    case square
    case cube
    case gauss
    case clamped
    case hat
    case sinh
    case sech
}

func RandomActivationFunction() -> ActivationFunction {
    let rand = Int.random(in: 1...13)
    switch rand {
    case 1:
        return .add
    case 2:
        return .sigmoid
    case 3:
        return .tanh
    case 4:
        return .relu
    case 5:
        return .sine
    case 6:
        return .abs
    case 7:
        return .square
    case 8:
        return .cube
    case 9:
        return .gauss
    case 10:
        return .clamped
    case 11:
        return .hat
    case 12:
        return .sinh
    case 13:
        return .sech
    default:
        return .sigmoid
    }
}
