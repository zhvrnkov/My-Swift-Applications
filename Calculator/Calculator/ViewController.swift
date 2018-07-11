//
//  ViewController.swift
//  Calculator
//
//  Created by Vladislav Zhavoronkov on 18/05/2018.
//  Copyright © 2018 Vladislav Zhavoronkov. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var chars: String = ""
    var nums: String = ""
    var sign: String = ""

    @IBOutlet weak var labelNum: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(chars, labelNum)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            numberPressed(sender.currentTitle!)
        } else if sender.tag == 2 {
            signPressed(sender.currentTitle!)
        } else if sender.tag == 3 {
            equalPressed()
        } else if sender.tag == 4 {
            exButtonsPressed(sender.currentTitle!)
        }
    }
    
    func numberPressed(_ char: String) {
        if chars.count > 12 {
            return
        } else if char == "0" && chars == "0" {
            return
        } else if char != "0" && chars == "0" {
            chars = ""
        }
        chars = chars + char
        updateUI(chars, labelNum)
    }
    
    func signPressed(_ char: String) {
        sign = char
        nums = chars
        chars = ""
        updateUI(chars, labelNum)
        print("chars: \(chars), nums: \(nums)")
    }
    
    func equalPressed() {
        switch sign {
        case "+":
            chars = String(Double(nums)! + Double(chars)!)
        case "-":
            chars = String(Double(nums)! - Double(chars)!)
        case "x":
            chars = String(Double(nums)! * Double(chars)!)
        case "÷":
            chars = String(Double(nums)! / Double(chars)!)
        default:
            print("Not found")
        }
        
//        if chars[chars.count - 1] == "0" && chars[chars.count - 2] == "." {
//            chars.remove(at: chars.last)
//            chars.removeCharacters(from: ".")
//        }

//        print(chars[chars.count - 1])
        updateUI(chars, labelNum)
    }
    
    func exButtonsPressed(_ char: String) {
        switch char {
        case "%":
            chars = String(Int(chars)! / 100)
        case "+/-":
            chars = String(Int(chars)! * -1)
        case "C":
            chars = "0"
            sign = ""
            nums = ""
        default:
            print("Not found")
        }
        updateUI(chars, labelNum)
    }
    
    func updateUI(_ text: String, _ label: UILabel) {
        label.text = text
    }
    
}

