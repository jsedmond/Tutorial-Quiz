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
    @IBOutlet weak var resultView: UIView!
    
    
    @IBOutlet weak var resultViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultViewTopConstraint: NSLayoutConstraint!
    
    
    
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
            
            // load state
            loadState()
            
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
            
            // Set question label to alpha 0
            questionLabel.alpha = 0
            
            // Set the question label
            questionLabel.text = actualCurrentQuestion.questionText
            
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: { 
                
                self.questionLabel.alpha = 1
                
            }, completion: nil)
            
            // Create the answer buttons and place them into the scrollview
            createAnswerButtons()
            
            // Save state
            saveState()
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
                
                // Set the number label
                answerButton.setNumberLabel(answerNumber: index + 1)
                
                // TODO: Create and attach a tapguesturerecognizer
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(answerTapped(gestureRecognizer:)))
                
                answerButton.addGestureRecognizer(gestureRecognizer)
                
                // Set the answer buttom alpha = 0
                
                answerButton.alpha = 0
                
                // Place the answer button into the stackview
                answerStackView.addArrangedSubview(answerButton)
                
                // Calculate a delay
                let delayAmount = Double(index) * 0.2
                
                // Fade it in
                UIView.animate(withDuration: 0.5, delay: delayAmount, options: .curveEaseOut, animations: {
                    
                    answerButton.alpha = 1
                    
                }, completion: nil)
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
                
                changeResultViewColor(color: UIColor.green)
                
                // Increment counter
                numberCorrect += 1
                
            }
            else {
                // User got it wrong
                resultLabel.text = "Incorrect"
                
                changeResultViewColor(color: UIColor.red)
            }
            
            // Set the feedback label
            feedbackLabel.text = currentQuestion?.feedback
            
            // Set the button text
            resultButton.setTitle("Next", for: .normal)
            
            // Set the constraint constants to shift the feedback view out of view
            resultViewTopConstraint.constant = 1000
            resultViewBottomConstraint.constant = -1000
        
            // Layout views right away
            view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                
                // Update the constraints
                self.resultViewTopConstraint.constant = 30
                self.resultViewBottomConstraint.constant = 30
                
                self.view.layoutIfNeeded()
                
                // Show the feedback screen
                self.dimView.alpha = 1
                
            }, completion: { (Bool) in
                self.saveState()
            })
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
                
                // Remove the dim view
                dimView.alpha = 0
                
                // Display the next question
                displayCurrentQuestion()
            }
            else {
                // Quiz is over
                
                // Set the labels and buttons
                resultLabel.text = "Results"
                feedbackLabel.text = "Your score is \(numberCorrect) out of \(questions.count)"
                resultButton.setTitle("Restart", for: .normal)
                
                // Set the color for the background
                resultView.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.5)
                
                // Set the color for the button background
                resultButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
                
                // Display the feedback screen
                dimView.alpha = 1
                
                // Reset the locally stored values
                eraseState()
                
            }

            
        }
    }
    
    func changeResultViewColor(color:UIColor) {
        
        
        if color == UIColor.green {
            
            // Set the color for the background
            resultView.backgroundColor = UIColor(red: 72/255, green: 161/255, blue: 49/255, alpha: 0.5)
            
            // Set the color for the button background
            resultButton.backgroundColor = UIColor(red: 7/255, green: 58/255, blue: 15/255, alpha: 0.5)
            
        }
        else if color == UIColor.red {
            
            // Set the color for the background
            resultView.backgroundColor = UIColor(red: 161/255, green: 34/255, blue: 36/255, alpha: 0.5)
            
            // Set the color for the button background
            resultButton.backgroundColor = UIColor(red: 58/255, green: 19/255, blue: 16/255, alpha: 0.5)
        }
    }
    
  
    func saveState() {
        
        let defaults = UserDefaults.standard
        
        // Save the number correct
        defaults.set(numberCorrect, forKey: "numberCorrect")
        
        // Save the question index
        if currentQuestion != nil {
            let index = questions.index(of: currentQuestion!)
            
            if let actualIndex = index {
                defaults.set(actualIndex, forKey: "questionIndex")
            }
        }
        
        // Save the resultView visibility
        defaults.set(dimView.alpha == 1.0, forKey: "resultViewVisibility")
        
        // Save the result view title
        defaults.set(resultLabel.text, forKey: "resultViewTitle")
        
        defaults.synchronize()
    }
    
    func loadState() {
        
        let defaults = UserDefaults.standard
        
        // Load the number correct
        if let actualNumberCorrect = defaults.value(forKey: "numberCorrect") as? Int
            {
            numberCorrect = actualNumberCorrect
        }
        
        // Load the question index
        if let actualQuestionIndex = defaults.value(forKey: "questionIndex") as? Int
        {
         // Check if the actualQuestionIndex is within the bounds of the question array
            if actualQuestionIndex < questions.count {
                currentQuestion = questions[actualQuestionIndex]
            }
        }
        // Load the resultView visibility
        if let actualVisibilty = defaults.value(forKey: "resultViewVisibility") as? Bool {
            
            // Show the feedback screen
            if actualVisibilty == true {
                
                // Get hte result title
                if let actualResultLableTitle = defaults.value(forKey: "resultViewTitle") as? String {
                    
                    resultLabel.text = actualResultLableTitle
                    
                    if actualResultLableTitle == "Correct!" {
                        // User had it correct, so set the result view to green
                        
                        changeResultViewColor(color: UIColor.green)
                    }
                    else {
                        // Set it to red
                        
                        changeResultViewColor(color: UIColor.red)
                    }
                }
                
                feedbackLabel.text = currentQuestion?.feedback
                
                dimView.alpha = 1
            }
        }
        
    }
    
    func eraseState() {
        
        let defaults = UserDefaults.standard
        
        // Erase the number correct
        defaults.set(0, forKey: "numberCorrect")
        
        // Erase the question index
        defaults.set(0, forKey: "questionIndex")
        
        // Erase the resultView visibility
        defaults.set(false, forKey: "resultViewVisibility")
        
        // Erase the resultView title
        defaults.set("", forKey: "resultViewTitle")
        
        // Synchronize
        defaults.synchronize()
    }
    
    
    
    
    
    
    

}

