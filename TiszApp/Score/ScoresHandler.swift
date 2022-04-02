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
        Database.database().reference().child("scores").observe(DataEventType.value) { snapshot in
            for child in snapshot.children {
                if let currSnapshot = child as? DataSnapshot,
                   let score = ScoreItem(snapshot: currSnapshot) {
                    self.scoresList.append(score)
                    self.sum1 += score.score1
                    self.sum2 += score.score2
                    self.sum3 += score.score3
                    self.sum4 += score.score4
                }
            }
            
        }
    }
    
    func deleteScores() {
        Database.database().reference().child("scores").removeValue()
        self.scoresList.removeAll()
        self.sum1 = 0
        self.sum2 = 0
        self.sum3 = 0
        self.sum4 = 0
    }
}
