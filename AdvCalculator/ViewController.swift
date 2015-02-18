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
    var brain = CalculatorBrain()


    
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
        brain.clear()
        display.text = "0"
        history.text = ""
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            history.text = history.text! + operation
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
            
        }
        
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
        
            if let result = brain.pushOperand(displayValue!) {
                displayValue = result
            } else {
                displayValue = nil
            }
            history.text = history.text! + "\(displayValue)"
        }
    }
    
    var displayValue: Double? {
        get {
    
           return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
        
    }

}

