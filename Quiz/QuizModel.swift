//
//  QuizModel.swift
//  Quiz
//
//  Created by Jacob Edmond on 5/7/17.
//  Copyright © 2017 Jacob Edmond. All rights reserved.
//

import UIKit

class QuizModel: NSObject {
    
    func getQuestions() -> [Question] {
     
        var questions = [Question]()
        
        // Get array of dictionaries from JSON file
        let array = getLocalJsonFile()
        
        // Parse ditionaries into Question objects
        for dict in array {
            
            // Create question object
            let q = Question()
            
            // Assign question properties
            q.questionText = dict["question"] as! String
            q.answers = dict["answers"] as! [String]
            q.correctAnswerIndex = dict["correctIndex"] as! Int
            q.module = dict["module"] as! Int
            q.lesson = dict["lesson"] as! Int
            q.feedback = dict["feedback"] as! String
            
            // Add the question object in the array
            questions += [q]
            
        }
        // Return the list of question objects
        
        return questions
    }
    
    func getLocalJsonFile() -> [[String:Any]] {
        
        do {
        
            // Get path to json file in bundle
            let bundlePath = Bundle.main.path(forResource: "QuestionData", ofType: "json")
            
            if let actualBundlePath = bundlePath {
                
                // Create url object
                let url = URL(fileURLWithPath: actualBundlePath)
                
                // Create data object
                let data = try Data(contentsOf: url)
                
                // Use JsonSerialization to turn data into array of dictionaries
                let array = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String:Any]]
                
                return array
            }
        }
        catch {
            // Something wrong happened
        }
        
        return [[String:Any]]()
    }

}
