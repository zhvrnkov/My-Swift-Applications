//
//  Card.swift
//  Set
//
//  Created by Vladislav Zhavoronkov on 23/06/2018.
//  Copyright © 2018 Vladislav Zhavoronkov. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int { return identifier }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return (lhs.identifier == rhs.identifier)
                && (lhs.isPicked == rhs.isPicked)
                && (lhs.glyph == rhs.glyph)
    }
    
    var isPicked = false
    var glyph: Character
    private var identifier: Int
    
    private static var identifierFactor = 0
    private static func getUniqueID() -> Int {
        identifierFactor += 1
        return identifierFactor
    }
    
    init(glyph: Character) {
        self.glyph = glyph
        self.identifier = Card.getUniqueID()
    }
}
