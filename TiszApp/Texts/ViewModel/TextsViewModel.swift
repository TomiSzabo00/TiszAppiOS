//
//  TextsHandler.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 09..
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import SwiftUI

enum TextHandlerMode {
    case na
    case loadTexts
    case getDetails
}

protocol TextsViewModel {
    var textInfos: [TextItem] { get }
    var user: User? { get }
    func getTextInfos()
    func getTextAuthorDetails(textInfo: TextItem)
}

final class TextsViewModelImpl: TextsViewModel, ObservableObject {
    
    @Published var textInfos: [TextItem] = []
    var mode: TextHandlerMode = .na
    @Published var user: User? = nil
    
    init(mode: TextHandlerMode){
        self.mode = mode
        
        if self.mode == .loadTexts {
            self.getTextInfos()
        }
       
    }
    
    func getTextInfos() {
        Database.database().reference().child("texts").observe(.childAdded, with: { (snapshot) -> Void in
            let textInfo = TextItem(snapshot: snapshot)
            guard let textInfo = textInfo, textInfo.author != "noAuthor" else { return }
            self.textInfos.insert(textInfo, at: 0)
        })
        
        Database.database().reference().child("texts").observe(.childRemoved, with: { (snapshot) -> Void in
            let textInfo = TextItem(snapshot: snapshot)
            guard let firstIndex = self.textInfos.firstIndex(where: { $0.id == textInfo?.id ?? "" }) else { return }
            self.textInfos.remove(at: firstIndex)
        })
    }
    
    func getTextAuthorDetails(textInfo: TextItem) {
        Database.database().reference().child("users").child(textInfo.author).observe(DataEventType.value, with: { snapshot in
            let author = User(snapshot: snapshot)
            self.user = author
          })
    }

    func deleteText(id: String) {
        Database.database().reference().child("texts").child(id).removeValue()
    }

    func uploadText(title: String, text: String, completion: @escaping (Bool) -> Void) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
        let id = dateFormatter.string(from: date)

        let textInfo = ["author" : Auth.auth().currentUser?.uid ?? "unknown",
                        "id" : id,
                        "title" : title,
                        "text" : text] as [String: Any]

        Database.database().reference().child("texts").child(id).setValue(textInfo) { (err, _) in
            if let err = err {
                print(err.localizedDescription)
                completion(false)
            }
            completion(true)
        }
    }
}

