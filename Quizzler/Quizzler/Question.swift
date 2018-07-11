//
//  Question.swift
//  Quizzler
//
//  Created by Vladislav Zhavoronkov on 16/05/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

class Question {
    let textQuestion: String
    let answer: Bool
    
    init(text: String, correctAnswer: Bool) {
        textQuestion = text
        answer = correctAnswer
    }
}
