//
//  exstension.swift
//  Set
//
//  Created by Vladislav Zhavoronkov on 23/06/2018.
//  Copyright © 2018 Vladislav Zhavoronkov. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func shuffle() {
        var num = self.count
        var array = self
        self.removeAll()
        for _ in array.indices{
            self.append(array.remove(at: num.arc4random))
            num -= 1
        }
    }
    func randomElement() -> Element {
        return self[count.arc4random]
    }
    func allEqual() -> Bool {
        if let firstElem = self.first {
            for elem in self {
                if elem != firstElem { return false }
            }
        }
        return true
    }
    mutating func removeThis(element: Element) {
//        self.remove(at: self.index(of: elem))
        if let indexOfElement = self.index(of: element) {
            self.remove(at: indexOfElement)
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
