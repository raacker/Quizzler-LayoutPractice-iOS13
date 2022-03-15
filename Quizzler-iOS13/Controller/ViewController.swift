//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionProgress: UIProgressView!
    @IBOutlet weak var buttonTrue: UIButton!
    @IBOutlet weak var buttonFalse: UIButton!
    
    var questionSet: QuestionSet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionSet = QuestionSet("quizset")
        updateUI()
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        if questionSet.getCurrentQuestion() != nil {
            let result = (sender.tag == 1)
            questionSet.answerToCurrentQuestion(answer: result)
        } else {
            questionSet.reset()
            resetUI()
        }
        updateUI()
    }
    
    func resetUI() {
        questionProgress.setProgress(0.0, animated: true)
        buttonFalse.setTitle("False", for: UIControl.State.normal)
        buttonTrue.isHidden = false
    }
    
    func updateUI() {
        if let question = questionSet.getCurrentQuestion() {
            questionLabel.text = question.text
            questionProgress.setProgress(questionSet.getCurrentProgress(), animated: true)
        } else {
            questionLabel.text = "Your Score is \(questionSet.score) / \(questionSet.getCurrenQuestionCount())"
            buttonFalse.setTitle("Restart", for: UIControl.State.normal)
            buttonTrue.isHidden = true
            
            questionProgress.setProgress(1.0, animated: true)
        }
    }
}

