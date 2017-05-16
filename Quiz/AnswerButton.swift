//
//  AnswerButton.swift
//  Quiz
//
//  Created by Jacob Edmond on 5/15/17.
//  Copyright © 2017 Jacob Edmond. All rights reserved.
//

import UIKit

class AnswerButton: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var numberStackView = UIStackView()
    var answerStackView = UIStackView()
    
    var numberLabel = UILabel()
    var answerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set axis to horizontal
        axis = .horizontal
        
        // Initialize answer label and stackview
        answerStackView.addArrangedSubview(answerLabel)
        answerStackView.alignment = .center
        addArrangedSubview(answerStackView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAnswerText(answerText:String) {
        
        // Set the answer label
        answerLabel.textAlignment = .center
        answerLabel.text = answerText
    }
}
