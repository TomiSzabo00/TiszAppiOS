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
    var sum1: Int { get }
    var sum2: Int { get }
    var sum3: Int { get }
    var sum4: Int { get }
    func getScores()
    func deleteScores()
}

final class ScoresHandlerImpl: ScoresHandler, ObservableObject {
    @Published var scoresList: [ScoreItem] = []
    
    @Published var sum1: Int = 0
    @Published var sum2: Int = 0
    @Published var sum3: Int = 0
    @Published var sum4: Int = 0
    
    init(){
        getScores()
    }
    
    func getScores(){
        Database.database().reference().child("scores").observe(.childAdded, with: { (snapshot) -> Void in
               if let score = ScoreItem(snapshot: snapshot) {
                self.scoresList.append(score)
                self.sum1 += score.score1
                self.sum2 += score.score2
                self.sum3 += score.score3
                self.sum4 += score.score4
            }
        })
        
        Database.database().reference().child("scores").observe(.childRemoved, with: { (snapshot) -> Void in
               if let score = ScoreItem(snapshot: snapshot) {
                self.scoresList.remove(at: self.scoresList.firstIndex(where: {
                    $0.name == score.name &&
                    $0.score1 == score.score1 &&
                    $0.score2 == score.score2 &&
                    $0.score3 == score.score3 &&
                    $0.score4 == score.score4 &&
                    $0.author == score.author })!)
                self.sum1 -= score.score1
                self.sum2 -= score.score2
                self.sum3 -= score.score3
                self.sum4 -= score.score4
            }
            
        })
    }
    
    func deleteScores() {
        Database.database().reference().child("scores").removeValue()
    }
}
