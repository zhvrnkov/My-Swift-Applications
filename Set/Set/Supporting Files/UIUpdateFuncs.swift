//
//  UIUpdateFuncs.swift
//  Set
//
//  Created by Vladislav Zhavoronkov on 25/06/2018.
//  Copyright © 2018 Vladislav Zhavoronkov. All rights reserved.
//

import Foundation

func updateCards(operationID: Int) {
    switch operationID {
    case 1:
        cards.forEach {
            if let index = cards.index(of: $0) {
                $0.setTitle(String(game.cards[index].glyph), for: .normal)
            }
        }
    case 2:
        cards.forEach {
            if let index = cards.index(of: $0) {
                
                if game.cards[index].isPicked {
                    $0.backgroundColor = ($0.currentTitle == "♦️" || $0.currentTitle ==  "♥️") ? UIColor.black : UIColor.red
                } else {
                    $0.backgroundColor = game.cards[index].isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                }
                
            }
        }
    default:
        print("Unknown operation ID")
    }
}
