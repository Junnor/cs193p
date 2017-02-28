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
  
  var useIsInMiddleOfTyping = false
  
  
  @IBAction func touchDigit(_ sender: UIButton) {
    let value = sender.currentTitle!
    print("\(value) was selected")
    
    if useIsInMiddleOfTyping {
      let text = display.text!
      display.text = text + value
    } else {
      display.text = value
      useIsInMiddleOfTyping = true
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
  
  @IBAction func operate(_ sender: UIButton) {
    useIsInMiddleOfTyping = false
    
    if let title = sender.currentTitle {
      switch title {
      case "π":
        dispalyValue = Double.pi
        case "√":
        dispalyValue = sqrt(dispalyValue)
      default:
        break
      }
    }
  }
  
}

