//
//  ViewController.swift
//  Quiz
//
//  Created by Jacob Edmond on 5/7/17.
//  Copyright © 2017 Jacob Edmond. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerStackView: UIStackView!
    
    var currentQuestion:Question?
    
    let model = QuizModel()
    var questions = [Question]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Call get questions
        questions = model.getQuestions()
        
        // Check if there are questions
        if questions.count > 0 {
            
            currentQuestion = questions[0]
            
            // Display the current question
            displayCurrentQuestion()
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func displayCurrentQuestion() {
        
        if let actualCurrentQuestion = currentQuestion {
            
            // Set the question label
            questionLabel.text = actualCurrentQuestion.questionText
            
            // Create the answer buttons and place them into the scrollview
            createAnswerButtons()
        }
    }
    
    func createAnswerButtons() {
        
        if let actualCurrentQuestion = currentQuestion {
            
            for index in 0...actualCurrentQuestion.answers.count - 1 {
                
                // Create an answer button
                let answerButton = AnswerButton()
                answerButton.tag = index
                
                // Create a height constraint for it
                let heightConstraint = NSLayoutConstraint.init(item: answerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
                answerButton.addConstraint(heightConstraint)
                
                // Set the answer text
                answerButton.setAnswerText(answerText: actualCurrentQuestion.answers[index])
                
                // TODO: Create and attach a tapguesturerecognizer
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(answerTapped(gestureRecognizer:)))
                
                answerButton.addGestureRecognizer(gestureRecognizer)
                
                // Place the answer button into the stackview
                answerStackView.addArrangedSubview(answerButton)
                
            }
        }
        
    }
    
    
    func answerTapped(gestureRecognizer:UITapGestureRecognizer){
        
        // Detect which button was tapped
        if gestureRecognizer.view as? AnswerButton != nil {
            
            // Definitely view property is not nil and IS an answerbutton object
            let answerButton = gestureRecognizer.view as! AnswerButton
            
            if answerButton.tag == currentQuestion?.correctAnswerIndex {
                // User got it correct
                print("correct")
                
            }
            else {
                // User got it wrong
                print("wrong")
            }
            
        }
    }
    
    
    
    
    
    

}

