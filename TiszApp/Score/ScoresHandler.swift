//
//  ScoresHandler.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 02..
//

import Foundation
import FirebaseDatabase

protocol ScoresHandler {
    var scoresList: [ScoreItem] { get }
    var sums: [Int] { get }
    var picSums: [Int] { get }
    func getScores()
    func deleteScores()
    func deleteScore(score: ScoreItem)
}

final class ScoresHandlerImpl: ScoresHandler, ObservableObject {
    @Published var scoresList: [ScoreItem] = []
    
    @Published var sums: [Int] = []
    
    @Published var picSums: [Int] = []
    
    private var teamNum: Int
    
    init(teamNum: Int){
        self.teamNum = teamNum
        for _ in 0...self.teamNum-1 {
            sums.append(0)
            picSums.append(0)
        }
        getScores()
    }
    
    func getScores(){
        Database.database().reference().child("scores").observe(.childAdded, with: { (snapshot) -> Void in
               if let score = ScoreItem(snapshot: snapshot) {
                   self.scoresList.append(score)
                   for i in 0...self.teamNum-1 {
                       guard score.scores.indices.contains(i) else { return }
                       self.sums[i] += score.scores[i]
                   }
                   if(score.name.starts(with: "kép: ")) {
                       for i in 0...self.teamNum-1 {
                           self.picSums[i] += score.scores[i]
                       }
                   }
               }
        })
        
        Database.database().reference().child("scores").observe(.childRemoved, with: { (snapshot) -> Void in
               if let score = ScoreItem(snapshot: snapshot) {
                self.scoresList.remove(at: self.scoresList.firstIndex(where: {$0.id == score.id})!)
                   for i in 0...self.teamNum-1 {
                       guard score.scores.indices.contains(i) else { return }
                       self.sums[i] -= score.scores[i]
                   }
                   if(score.name.starts(with: "kép: ")) {
                       for i in 0...self.teamNum-1 {
                           self.picSums[i] -= score.scores[i]
                       }
                   }
            }
            
        })
        
        Database.database().reference().child("scores").observe(.childChanged, with: { (snapshot) -> Void in
               if let score = ScoreItem(snapshot: snapshot) {
                //find old one
                let oldScore = self.scoresList[self.scoresList.firstIndex(where: {$0.id == score.id})!]
                   for i in 0...self.teamNum-1 {
                       guard oldScore.scores.indices.contains(i) else { return }
                       self.sums[i] -= oldScore.scores[i]
                   }
                   if(score.name.starts(with: "kép: ")) {
                       for i in 0...self.teamNum-1 {
                           self.picSums[i] -= score.scores[i]
                       }
                   }
                   
                //change to new
               self.scoresList[self.scoresList.firstIndex(where: {$0.id == score.id})!] = score
                   for i in 0...self.teamNum-1 {
                       guard score.scores.indices.contains(i) else { return }
                       self.sums[i] += score.scores[i]
                   }
                   if(score.name.starts(with: "kép: ")) {
                       for i in 0...self.teamNum-1 {
                           self.picSums[i] += score.scores[i]
                       }
                   }
            }
            
        })
    }
    
    func deleteScores() {
        Database.database().reference().child("scores").removeValue()
    }
    
    func deleteScore(score: ScoreItem) {
        Database.database().reference().child("scores").child(score.id).removeValue()
    }
}
