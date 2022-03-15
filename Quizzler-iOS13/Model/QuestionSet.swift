//
//  Question.swift
//  Quizzler-iOS13
//
//  Created by Haven on 2022-03-13.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Question{
    let text: String
    let answer: Bool
    
    init(_ text: String, _ answer: Bool) {
        self.text = text
        self.answer = answer
    }
}

class QuestionSet {
    // Only possible to set internally but get is at default level of access
    private var questions: [[Question]]
    private(set) var currentQuestionIdx: Int
    private(set) var score: Int
    private var currentQuestionSet: [Question]
    
    init(_ jsonString: String) {
        self.questions = [[Question]]()
        self.currentQuestionIdx = 0
        self.score = 0
        self.currentQuestionSet = [Question]()
        
        fillQuestions(jsonString)
        reset()
    }
    
    func getCurrenQuestionCount() -> Int {
        return currentQuestionSet.count
    }
    
    func getCurrentProgress() -> Float {
        return Float(currentQuestionIdx) / Float(currentQuestionSet.count)
    }
    
    func getCurrentQuestion() -> Question! {
        if currentQuestionIdx >= currentQuestionSet.endIndex {
            return nil
        }
        
        return currentQuestionSet[currentQuestionIdx]
    }
    
    func answerToCurrentQuestion(answer: Bool) {
        if currentQuestionIdx >= currentQuestionSet.endIndex {
            return
        }
        
        if currentQuestionSet[currentQuestionIdx].answer == answer {
            score += 1
        }
        currentQuestionIdx += 1
    }
    
    func reset() {
        score = 0
        currentQuestionIdx = 0
        currentQuestionSet = questions[Int.random(in: 0..<questions.count)]
    }
    
    func fillQuestions(_ jsonString: String) {
        if let path = Bundle.main.path(forResource: jsonString, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                for quizSet in jsonObj["data"].arrayValue {
                    var newQuestionSet = [Question]()
                    
                    for quizs in quizSet {
                        let quiz = quizs.1.arrayValue
                        print(quiz[0])
                        print(quiz[1])
                        
                        guard let questionText = quiz[0].string else { continue }
                        guard let questionAnswer = quiz[1].bool else { continue }
                        newQuestionSet.append(Question(questionText, questionAnswer))
                    }
                    
                    questions.append(newQuestionSet)
                }
            } catch {
                print("Unexpected error: \(error).")
            }
        }
    }
}
