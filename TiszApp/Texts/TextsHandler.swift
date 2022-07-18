//
//  TextsHandler.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 09..
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import SwiftUI

enum TextHandlerMode {
    case na
    case loadTexts
    case getDetails
}

protocol TextsHandler {
    var textInfos: [TextItem] { get }
    var user: User? { get }
    func getTextInfos()
    func getTextAuthorDetails(textInfo: TextItem)
}

final class TextsHandlerImpl: TextsHandler, ObservableObject {
    
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
            self.textInfos.insert(textInfo ?? TextItem(), at: 0)
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
}

