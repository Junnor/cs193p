//
//  ViewController.swift
//  Calculator
//
//  Created by Ju on 2017/2/28.
//  Copyright © 2017年 Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var display: UILabel!
  
  var useIsInTheMiddleOfTyping = false
  
  
  @IBAction func touchDigit(_ sender: UIButton) {
    let value = sender.currentTitle!
    print("\(value) was selected")
    
    if useIsInTheMiddleOfTyping {
      let text = display.text!
      display.text = text + value
    } else {
      display.text = value
      useIsInTheMiddleOfTyping = true
    }
  }
  
  var dispalyValue: Double {
    get {
      return Double(display.text!)!
    }
    set {
      display.text = String(newValue)
    }
  }
  
  private var brain = CalculatorBrain()
  
  /*
   1: set operand
   
   2: set operation
   
   3: display value
 
 */
  @IBAction func operate(_ sender: UIButton) {
    if useIsInTheMiddleOfTyping {
      brain.setOperand(dispalyValue)
      
      useIsInTheMiddleOfTyping = false
    }
    
    if let symbol = sender.currentTitle {
      brain.performOperation(symbol)
    }
    
    if let result = brain.result {
      dispalyValue = result
    }
  }
  
}

