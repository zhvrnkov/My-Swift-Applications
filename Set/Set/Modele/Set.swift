//
//  Set.swift
//  Set
//
//  Created by Vladislav Zhavoronkov on 23/06/2018.
//  Copyright © 2018 Vladislav Zhavoronkov. All rights reserved.
//

import Foundation

class Set {
    private(set) var deck = [Card]()
    private(set) var board: Array<Card?> = Array(repeating: nil, count: 24)
    private(set) var stringOfSuits: [Character]
    private(set) var cardsInDeck = 81
    private(set) var scoreCount = 0 {
        didSet {
            if scoreCount < 0 {
                scoreCount = 0
            }
        }
    }
    private(set) var lastCards = [Card]()


    func chooseCard(at index: Int, cb: (() -> Void)? = nil) {
        if !board[index]!.isPicked {
            checkCards(cb: cb)
            
            board[index]!.isPicked = true
            lastCards.append(board[index]!)
            
        } else if lastCards.count < 3 {
            lastCards.removeThis(element: board[index]!)
            board[index]!.isPicked = false
            scoreCount -= 1
        }
    }
    
    func checkCards(cb: (() -> Void)? = nil) {
        if lastCards.count == 3 {
            if lastCards.allEqual() {
                for card in lastCards {
                    if board.contains(card) {
                        board[board.index(of: card)!] = nil
                        lastCards.removeThis(element: card)
                    }
                }
                cb?()
                scoreCount += 3
            } else {
                for index in board.indices {
                    board[index]?.isPicked = false
                }
                scoreCount -= 5
            }
            lastCards.removeAll()
        }
    }
    
    func putCardsOnBoard(amount: Int, cb: (() -> Void)? = nil) {
        if deck.count < amount, board.count < amount { return }
        var countOfIterations = amount
        for index in board.indices {
            if board[index] == nil, countOfIterations > 0, deck.indices.contains(index) {
                board[index] = deck.remove(at: index)
                countOfIterations -= 1
            }
        }
        cb?()
    }


    init(suits: String, cardsOnBoard: Int) {
        stringOfSuits = Array(suits)
        
        for suit in stringOfSuits {
            let card = Card(glyph: suit)
            deck += Array(repeating: card, count: cardsInDeck/stringOfSuits.count)
        }
        deck.shuffle()
        
        putCardsOnBoard(amount: cardsOnBoard)
        
    }
}





















