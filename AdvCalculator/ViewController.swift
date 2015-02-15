//
//  ViewController.swift
//  AdvCalculator
//
//  Created by Aloha Hsu on 2015/2/8.
//  Copyright (c) 2015年 Aloha Hsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


   
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    //var userIsInTheMiddleOfTypingANumber: Bool = false
    
    var userIsInTheMiddleOfTypingANumber = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        history.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            
            if digit == "." && display.text!.rangeOfString(".") != nil {
                return
                
            } else if digit != "." {
                display.text = display.text! + digit
            }
            
        } else {
            
            if digit == "." {
                display.text = "0."
                
            } else {
                display.text = digit
                
            }
            userIsInTheMiddleOfTypingANumber = true
        }
        
    }
    
    @IBAction func clear(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.removeAll(keepCapacity: false)
        display.text = "0"
        history.text = ""
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        history.text = history.text! + operation
        
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $0 / $1 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $0 - $1 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0)}
        case "cos": performOperation { cos($0) }
        case "π": performOperation()
            
        default: break
            
        }
        
    }
    
    
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation() {
        displayValue = M_PI
        enter()
    }
    
    // var operandStack: Array<Double> = Array<Double>()
    var operandStack = Array<Double>()

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        history.text = history.text! + "\(displayValue)"
    }
    
    var displayValue: Double {
        get {
    
           return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
        
    }

}

