//
//  ScoreItem.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 02..
//

import Foundation
import FirebaseDatabase

struct ScoreItem: Decodable, Identifiable, Hashable {
    var id: String
    
    var score1: Int
    var score2: Int
    var score3: Int
    var score4: Int
    var name: String
    var author: String
    
    init(id: String, score1: Int, score2: Int, score3: Int, score4: Int, name: String, author: String) {
        self.id = id
        self.score1 = score1
        self.score2 = score2
        self.score3 = score3
        self.score4 = score4
        self.name = name
        self.author = author
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let id = value["id"] as? String,
            let score1 = value["score1"] as? Int,
            let score2 = value["score2"] as? Int,
            let score3 = value["score3"] as? Int,
            let score4 = value["score4"] as? Int,
            let author = value["author"] as? String,
            let name = value["name"] as? String
        else {
            return nil
        }
        self.id = id
        self.score1 = score1
        self.score2 = score2
        self.score3 = score3
        self.score4 = score4
        self.name = name
        self.author = author
    }
}
