//
//  MultipleTextQuizViewController.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 14..
//

import Foundation

final class MultipleTextQuizViewModel: ObservableObject {
    
    private(set) var numOfQuestions: Int = 0
    
    @Published var answers = [[String]]()
    
    
    func setNumOfQuestions(num: Int) {
        self.numOfQuestions = num
        for _ in 1...self.numOfQuestions {
            self.answers.append([])
        }
    }
    
}
