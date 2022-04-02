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
    func getScores()
}

final class ScoresHandlerImpl: ScoresHandler, ObservableObject {
    @Published var scoresList: [ScoreItem] = []
    
    init(){
        getScores()
    }
    
    func getScores(){
        Database.database().reference().child("scores").observe(DataEventType.value) { snapshot in
            for child in snapshot.children {
                if let currSnapshot = child as? DataSnapshot,
                   let score = ScoreItem(snapshot: currSnapshot) {
                    self.scoresList.append(score)
                }
            }
            
        }
    }
}
