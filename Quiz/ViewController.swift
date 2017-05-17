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
    
    // Feedback screen
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var resultButton: UIButton!
    
    var currentQuestion:Question?
    
    let model = QuizModel()
    var questions = [Question]()
    
    var numberCorrect = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Hide feedback screen
        dimView.alpha = 0
        
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
                resultLabel.text = "Correct"
                
                // Increment counter
                numberCorrect += 1
                
            }
            else {
                // User got it wrong
                resultLabel.text = "Incorrect"
            }
            
            // Set the feedback label
            feedbackLabel.text = currentQuestion?.feedback
            
            // Set the button text
            resultButton.setTitle("Next", for: .normal)
            
            // Show the feedback screen
            dimView.alpha = 1
        }
    }
    
    
    
    @IBAction func resultButtonTapped(_ sender: Any) {
        
        // Remove the answer buttons
        for view in answerStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        // Check the text of the resultButton.  If it's restart then restart the quiz
        let currentTitle = resultButton.title(for: .normal)
        
        // Check if there's a title
        if let actualTitle = currentTitle {
            if actualTitle == "Restart" {
                // Restart the quiz
                
                
                // Set the current question to the first one
                currentQuestion = questions[0]
                displayCurrentQuestion()
                
                // Get ride of the result screen
                dimView.alpha = 0
                
                // Reset score
                numberCorrect = 0
                
                return
            }
        }
        

        // Determine what infex the current question is within the questions array
        let indexOfCurrentQuestion = questions.index(of: currentQuestion!)
        
        if let actualIndex = indexOfCurrentQuestion {
        
            // Increment the index
            let nextIndex = actualIndex + 1
        
            // Check that it's within bounds of the questions array
            if nextIndex < questions.count {
                
                // Set the new current question
                currentQuestion = questions[nextIndex]
                
                // Display the next question
                displayCurrentQuestion()
                
                // Remove the dim view
                dimView.alpha = 0
            }
            else {
                // Quiz is over
                
                // Set the labels and buttons
                resultLabel.text = "Results"
                feedbackLabel.text = "Your score is \(numberCorrect) out of \(questions.count)"
                resultButton.setTitle("Restart", for: .normal)
                
                // Display the feedback screen
                dimView.alpha = 1
                
            }

            
        }
    }
    
  
    
    
    
    
    
    
    
    

}

