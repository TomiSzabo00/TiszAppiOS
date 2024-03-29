//
//  ImageItem.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseStorage

let placeholder: UIImage = UIImage(systemName: "arrow.2.circlepath") ?? UIImage()

struct ImageItem: Identifiable, Equatable {
    var id: UUID = UUID()
    
    var title: String
    var fileName: String
    var author: String
    var score: Int
    var scorerUID: String
    
    init(title: String, fileName: String, author: String, score: Int, scorerUID: String) {
        self.title = title
        self.fileName = fileName
        self.author = author
        self.score = score
        self.scorerUID = scorerUID
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let title = value["title"] as? String,
            let author = value["author"] as? String,
            let fileName = value["fileName"] as? String,
            let score = value["score"] as? Int,
            let scorerUID = value["scorerUID"] as? String
        else {
            return nil
        }
        
        self.title = title
        self.fileName = fileName
        self.author = author
        self.score = score
        self.scorerUID = scorerUID
    }

    init() {
        self.title = "error"
        self.fileName = "noFile"
        self.author = "noAthor"
        self.score = 0
        self.scorerUID = "noUidInfo"
    }
}

///source:  https://benmcmahen.com/firebase-image-in-swiftui/
final class Loader : ObservableObject {

    @Published var data: Data? = nil

    init(_ id: String?){
        if let id = id {
            let url = "images/\(id)"
            let storage = Storage.storage()
            let ref = storage.reference().child(url)
            ref.getData(maxSize: 2 * 1024 * 1024) { data, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                }

                DispatchQueue.main.async {
                    self.data = data
                }
            }
        }
    }
}
