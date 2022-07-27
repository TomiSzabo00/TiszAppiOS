//
//  MultipleTextQuizViewController.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 14..
//

import Foundation
import FirebaseDatabase
import SwiftUI

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
    
    @Published var itemColors = [Color]()

    @Published var errorAlert = false

    @Published var saves = [String]()
    @Published var savedSnapshots = [DataSnapshot]()

    var currTeam = -1
    
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
        
        Database.database().reference().child("text-quiz-answers").removeValue()
    }
    
    private func setUpAnswers(for: Int) {
        self.numOfQuestions = `for`
        if(`for` > 0) {
            for _ in 1...`for` {
                self.answers.append(Answer(answer: ""))
                self.itemColors.append(.white)
            }
        } else {
            self.answers.removeAll()
            self.itemColors.removeAll()
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
            self.itemColors.removeAll()
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
        Database.database().reference().child("text-quiz-answers").child(String(sessionService?.userDetails?.groupNumber ?? -1)).child(sessionService?.userDetails?.uid ?? "error_noUidInfo").setValue(answer) { error, _ in
            if let error = error {
                print(error.localizedDescription)
                self.errorAlert = true
            }
        }

        self.canUpload = false
    }
    
    func initUploadListener() {
        Database.database().reference().child("text-quiz-answers").observe(.childAdded, with: { (snapshot) -> Void in
            if snapshot.hasChild(self.sessionService?.userDetails?.uid ?? "error_noUidInfo") {
                self.canUpload = false
                print("van")
            } else {
                self.canUpload = true
            }
        })
        
        Database.database().reference().child("text-quiz-answers").observe(.childRemoved, with: { (snapshot) -> Void in
            if snapshot.hasChild(self.sessionService?.userDetails?.uid ?? "error_noUidInfo") {
                self.canUpload = true
            }
        })
    }
    
    func getAllAnswers() {
        self.allAnswers.removeAll()
        for _ in 1...(self.sessionService?.teamNum ?? 1) {
            self.allAnswers.append([])
        }
        Database.database().reference().child("text-quiz-answers").observe(.childAdded, with: { (snapshot) -> Void in
            let groupNum = (Int(snapshot.key) ?? 1)-1
            for child in snapshot.children {
                let currChild = child as? DataSnapshot
                let value = currChild?.value as? [String: [String]],
                    currAnswers = value?["answers"]
                
                if(self.allAnswers[groupNum].count != self.numOfQuestions) {
                    self.allAnswers[groupNum].removeAll()
                    for _ in 0...self.numOfQuestions-1 {
                        self.allAnswers[groupNum].append([])
                    }
                }
                
                for i in 0...self.numOfQuestions-1 {
                    self.allAnswers[groupNum][i].append(Answer(answer: currAnswers?[i] ?? "errorLoadingAnswers"))
                }
            }
        })
    }

    func saveScores() {
        let score = Double(itemColors.filter{$0 == .green}.count) + Double(itemColors.filter{$0 == .yellow}.count) / 2

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
        let id = dateFormatter.string(from: Date())

        Database.database().reference().child("text-quiz-scores").child(String(currTeam)).child(id)
            .setValue(score)
    }

    func saveAnswers() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
        let id = dateFormatter.string(from: Date())

        Database.database().reference().child("text-quiz-answers").observeSingleEvent(of: .value) { snapshot in
            Database.database().reference().child("text-quiz-saves").child(id).setValue(snapshot.value)
        }

        removeNumOfQuestions()
    }

    func getSavedAnswers(from snapshot: DataSnapshot) {
        self.allAnswers.removeAll()
        for _ in 1...(self.sessionService?.teamNum ?? 1) {
            self.allAnswers.append([])
        }
        snapshot.children.forEach { teams in
            if let teamSnapshot = teams as? DataSnapshot {
                let groupNum = (Int(teamSnapshot.key) ?? 1)-1
                for child in teamSnapshot.children {
                    let currChild = child as? DataSnapshot

                    let numOfAnswers = Int(currChild?.childSnapshot(forPath: "answers").childrenCount ?? 0)

                    let value = currChild?.value as? [String: [String]],
                        currAnswers = value?["answers"]

                    if(self.allAnswers[groupNum].count != numOfAnswers) {
                        self.allAnswers[groupNum].removeAll()
                        self.itemColors.removeAll()
                        for _ in 0..<numOfAnswers {
                            self.allAnswers[groupNum].append([])
                            self.itemColors.append(.white)
                        }
                    }

                    for i in 0..<numOfAnswers {
                        self.allAnswers[groupNum][i].append(Answer(answer: currAnswers?[i] ?? "errorLoadingAnswers"))
                    }
                }
            } else {
                print("hiba a mentes beolvasasakor")
            }
        }
    }

    func getSaves() {
        self.saves.removeAll()
        self.savedSnapshots.removeAll()
        Database.database().reference().child("text-quiz-saves").observe(.childAdded) { snapshot in
            let data = snapshot.key

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"

            let decoded = dateFormatter.date(from:data) ?? Date()

            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"


            self.saves.append(dateFormatter.string(from: decoded))
            self.savedSnapshots.append(snapshot)
        }
    }
}
