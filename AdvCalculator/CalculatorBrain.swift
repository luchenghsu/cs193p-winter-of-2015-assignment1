//
//  CalculatorBrain.swift
//  AdvCalculator
//
//  Created by Aloha Hsu on 2015/2/14.
//  Copyright (c) 2015年 Aloha Hsu. All rights reserved.
//

import Foundation

class CalculatorBrain: Printable {
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    var variableValues = [String:Double]()
    
    var description: String {
        get {
            
            var (result, ops) = ("", opStack)
            while ops.count > 0 {
                var current: String?
                (current, ops) = description(ops)
                if result == "" {
                    result = current!
                } else {
                    result = current! + ", " + result
                }
            }
            return result
        }
    }
    
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
                
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
                
            case .Variable(let symbol):
                return (symbol, remainingOps)
                
            case .ConstantOperation(let symbol, _):
                return (symbol, remainingOps)
                
            case .UnaryOperation(let symbol, _):
                let operandEvaluation = description(remainingOps)
                if let operand = operandEvaluation.result {
                    return ("\(symbol)(\(operand))", operandEvaluation.remainingOps)
                }
                
            case .BinaryOperation(let symbol, _):
                
                let op1Evaluation = description(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = description(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        if op2Evaluation.remainingOps.isEmpty {
                             return ("\(operand2) \(symbol) \(operand1)", op2Evaluation.remainingOps)
                        }
                        return ("(\(operand2) \(symbol) \(operand1))", op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return ("?", ops)
    }
    
    private enum Op: Printable {
        case Operand(Double)
        case Variable(String)
        case BinaryOperation(String, (Double, Double) -> Double)
        case UnaryOperation(String, Double -> Double)
        case ConstantOperation(String, () -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Variable(let symbol):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .ConstantOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    init() {
        
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", { $0 * $1 }))
        learnOp(Op.BinaryOperation("÷", { $1 / $0 }))
        learnOp(Op.BinaryOperation("+", { $0 + $1 }))
        learnOp(Op.BinaryOperation("−", { $1 - $0 }))
        learnOp(Op.UnaryOperation("√", { sqrt($0) }))
        learnOp(Op.UnaryOperation("sin", { sin($0) }))
        learnOp(Op.UnaryOperation("cos", { cos($0) }))
        learnOp(Op.ConstantOperation("π", { M_PI }))
    }
    
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
    
            switch op {
                
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .Variable(let symbol):
                return (variableValues[symbol], remainingOps)
                
            case .ConstantOperation(_, let operation):
                return (operation(), remainingOps)
    
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
              
            case .BinaryOperation(_, let operation):
        
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    private func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        //println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String, value: Double) -> Double? {
        variableValues[symbol] = value
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear() {
        opStack.removeAll(keepCapacity: false)
        variableValues.removeAll(keepCapacity: false)
    }
    
}
