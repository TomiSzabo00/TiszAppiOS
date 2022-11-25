//
//  ScoreItem.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 02..
//

import Foundation
import FirebaseDatabase
import SwiftUI

struct Scores: Decodable, Hashable {
    var id: Int
    var score: Int
    
    init(id: Int, score: Int) {
        self.id = id
        self.score = score
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let id = value["id"] as? Int,
            let score = value["score"] as? Int
        else {
            return nil
        }
        self.id = id
        self.score = score
    }
}

struct ScoreItem: Decodable, Identifiable, Hashable {
    var id: String
    var scores: [Int]
    var name: String
    var author: String
    
    init(id: String, scores: [Int], name: String, author: String) {
        self.id = id
        self.scores = scores
        self.name = name
        self.author = author
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let id = value["id"] as? String,
            let scores = value["scores"] as? [Int],
            let author = value["author"] as? String,
            let name = value["name"] as? String
        else {
            return nil
        }
        self.id = id
        self.scores = scores
        self.name = name
        self.author = author
    }
}
