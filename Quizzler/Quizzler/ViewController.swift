//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let allQuestions = QuestionBank()
    var questionCount = 0
    var score = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "Score:\(score)"
        nextQuestion()
        
    }


    @IBAction func answerPressed(_ sender: UIButton) {
        let pickedAnswer: Bool
        pickedAnswer = sender.tag == 1 ? true : false
        checkAnswer(answer: pickedAnswer)
        questionCount += 1
        nextQuestion()
    }
    
    
    func updateUI() {
        progressLabel.text = "\(questionCount + 1)/\(allQuestions.list.count)"
        scoreLabel.text = "Score:\(score)"
        
        progressBar.frame.size.width = (view.frame.size.width / 13) * CGFloat(questionCount + 1)
    }
    

    func nextQuestion() {
        if questionCount > 12 {
            let alert = UIAlertController(title: "Awesome", message: "Do you want to restart the game?", preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "Restart", style: .default) { (UIAlertAction) in
                self.startOver()
            }
            
            alert.addAction(restartAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            questionLabel.text = allQuestions.list[questionCount].textQuestion
            updateUI()
        }
    }
    
    
    func checkAnswer(answer: Bool) {
        if allQuestions.list[questionCount].answer == answer {
            score += 1
            
            ProgressHUD.showSuccess("Correct")
        } else {
            ProgressHUD.showError("Wrong!")
        }
    }
    
    
    func startOver() {
        questionCount = 0
        score = 0
        scoreLabel.text = "Score:\(score)"
        nextQuestion()
    }
    

    
}
