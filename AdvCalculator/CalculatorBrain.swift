//
//  CalculatorBrain.swift
//  AdvCalculator
//
//  Created by Aloha Hsu on 2015/2/14.
//  Copyright (c) 2015年 Aloha Hsu. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    private enum Op: Printable {
        case Operand(Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case UnaryOperation(String, Double -> Double)
        case ConstantOperation(String, () -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
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
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double)-> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        println("symbol=\(symbol)")
        if let operation = knownOps[symbol] {
            println("perform Operation inside if let operation=")
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear() {
        opStack.removeAll(keepCapacity: false)
    }
    
}
