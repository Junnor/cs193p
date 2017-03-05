//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ju on 2017/3/2.
//  Copyright © 2017年 Ju. All rights reserved.
//


/*
 // --- 1 ---
 the method "setOperand" and "performOperaion" are public, and also the "result"
 */

/*
 // --- 2 ---
 -> method "performOperation"
 -> dictionary "operations" 
 -> enum "Operation": set "constant" and "unaryOperation"
 -> method "performOperation" 
 -> enum "Operation": set "binaryOperaion" and "equls" 
 -> struct "PendingBinaryOperation"
 -> aswsome "closure" "± × ÷ + −" in method "performOperation"
 */

import Foundation


struct CalculatorBrain {
  
  private var accumulator: Double?
  
  private enum Operation {
    case constant(Double)
    case unaryOperation((Double) -> Double)
    case binaryOperaion((Double, Double) -> Double)
    case equals
  }
  
  private var operations: Dictionary<String, Operation> = [
    "π": Operation.constant(Double.pi),
    "e": Operation.constant(M_E),
    "√": Operation.unaryOperation(sqrt),
    "sin": Operation.unaryOperation(sin),
    "cos": Operation.unaryOperation(cos),
    "tan": Operation.unaryOperation(tan),
    "±": Operation.unaryOperation({ -$0 }),
    "×": Operation.binaryOperaion({ $0 * $1 }),
    "÷": Operation.binaryOperaion({ $0 / $1 }),
    "+": Operation.binaryOperaion({ $0 + $1 }),
    "−": Operation.binaryOperaion({ $0 - $1 }),
    "=": Operation.equals
  ]
  
  mutating func performOperation(_ symbol: String) {
    if let operation = operations[symbol] {
      switch operation {
      case .constant(let value):
        accumulator = value
      case .unaryOperation(let function):
        if accumulator != nil {
          accumulator = function(accumulator!)
        }
        
      case .binaryOperaion(let function):
        
        if accumulator != nil {
          pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
          accumulator = nil
        }
      case .equals:
        perforPendingBinaryOperation()
        
      }
    }
  }
  
  private mutating func perforPendingBinaryOperation() {
    if pendingBinaryOperation != nil && accumulator != nil {
      accumulator = pendingBinaryOperation!.perform(with: accumulator!)
      pendingBinaryOperation = nil
    }
  }
  
  private var pendingBinaryOperation: PendingBinaryOperation?
  
  private struct PendingBinaryOperation {
    let function: (Double, Double) -> Double
    let firstOperand: Double
    
    func perform(with secondOperand: Double) -> Double {
      return function(firstOperand, secondOperand)
    }
  }
  
  mutating func setOperand(_ operand: Double) {
    accumulator = operand
  }
  
  var result: Double? {
    return accumulator
  }
  
}
