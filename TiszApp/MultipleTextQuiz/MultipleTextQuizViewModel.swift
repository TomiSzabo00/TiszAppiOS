//
//  MultipleTextQuizViewController.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 14..
//

import Foundation
import FirebaseDatabase

struct Answer: Identifiable, Hashable {
    var id: UUID
    var answer: String
    
    init(id: UUID = UUID(), answer: String) {
        self.id = id
        self.answer = answer
    }
}


final class MultipleTextQuizViewModel: ObservableObject {
    
    var sessionService: SessionServiceImpl?
    
    @Published private(set) var numOfQuestions: Int = 0
    
    @Published var allAnswers = [[[Answer]]]()
    
    @Published var answers = [Answer]()
    
    @Published var canUpload = true
    
    init() {
        self.initNumListener()
    }
    
    func setNumOfQuestions(num: Int) {
        let numValue = ["num" : num] as [String : Int]
        Database.database().reference().child("text-quiz-num").child("numberOfQuestions").setValue(numValue)
    }
    
    func removeNumOfQuestions() {
        let numValue = ["num" : 0] as [String : Int]
        Database.database().reference().child("text-quiz-num").child("numberOfQuestions").setValue(numValue)
    }
    
    private func setUpAnswers(for: Int) {
        self.numOfQuestions = `for`
        if(`for` > 0) {
            for _ in 1...`for` {
                self.answers.append(Answer(answer: ""))
            }
        } else {
            self.answers.removeAll()
        }
    }
    
    private func initNumListener() {
        Database.database().reference().child("text-quiz-num").observe(.childAdded, with: { (snapshot) -> Void in
            guard
                let value = snapshot.value as? [String: Int],
                let num = value["num"]
            else {
                return
            }
            self.setUpAnswers(for: num)
        })
        
        Database.database().reference().child("text-quiz-num").observe(.childRemoved, with: { (snapshot) -> Void in
            self.numOfQuestions = 0
            self.answers.removeAll()
        })
        
        Database.database().reference().child("text-quiz-num").observe(.childChanged, with: { (snapshot) -> Void in
            guard
                let value = snapshot.value as? [String: Int],
                let num = value["num"]
            else {
                return
            }
            self.setUpAnswers(for: num)
        })
    }
    
    func sumbitAnswers() {
        var answer_strings = [String]()
        for i in 0...answers.count-1 {
            answer_strings.append(self.answers[i].answer)
        }
        let answer = ["answers" : answer_strings] as [String : [String]]
        Database.database().reference().child("text-quiz-answers").child(String(sessionService!.userDetails!.groupNumber)).child(sessionService!.userDetails!.uid).setValue(answer)

        self.canUpload = false
    }
    
    func initUploadListener() {
        Database.database().reference().child("text-quiz-answers").observe(.childAdded, with: { (snapshot) -> Void in
            if snapshot.hasChild(self.sessionService!.userDetails!.uid) {
                self.canUpload = false
            } else {
                self.canUpload = true
            }
        })
        
        Database.database().reference().child("text-quiz-answers").observe(.childRemoved, with: { (snapshot) -> Void in
            if snapshot.hasChild(self.sessionService!.userDetails!.uid) {
                self.canUpload = true
            }
        })
    }
    
    func getAllAnswers() {
        for _ in 1...(self.sessionService?.teamNum ?? 1) {
            self.allAnswers.append([])
        }
        Database.database().reference().child("text-quiz-answers").observe(.childAdded, with: { (snapshot) -> Void in
            let groupNum = snapshot.key
            for child in snapshot.children {
                let currChild = child as! DataSnapshot
                let value = currChild.value as? [String: [String]],
                    currAnswers = value?["answers"]
                
                for i in 0...self.numOfQuestions-1 {
                    self.allAnswers[Int(groupNum) ?? 0].append([])
                    for _ in 1...snapshot.childrenCount {
                        self.allAnswers[Int(groupNum) ?? 0][i].append(Answer(answer: currAnswers![i]))
                    }
                }
            }
        })
    }
    
}
