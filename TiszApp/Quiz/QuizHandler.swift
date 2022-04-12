//
//  QuizHandler.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 12..
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import SwiftUI

protocol QuizHandler {
    var isEnabled: Bool { get }
    var bgColor: Color { get }
    var userDetails: SessionUserDetails? { get set }
    func singnal()
    func youSignalled()
    func teamSignalled()
    func disabledButton()
    func enabledButton()
    func initListeners()
    func reset()
    func disable()
}

final class QuizHandlerImpl : QuizHandler, ObservableObject {
    

    @Published var isEnabled: Bool = true
    @Published var bgColor: Color = .green
    
    @Published var userDetails: SessionUserDetails? = nil
    
    func initListeners() {
        Database.database().reference().child("signals").observe(.childAdded, with: { (snapshot) -> Void in
            let signalInfo = snapshot.value as! String
            if signalInfo == self.userDetails?.uid {
                self.youSignalled()
            }
            else {
                Database.database().reference().child("users").child(signalInfo).observe(DataEventType.value, with: { snapshot in
                    let author = User(snapshot: snapshot)
                    if author?.groupNumber == self.userDetails?.groupNumber {
                        self.teamSignalled()
                    }
                  })
            }
            if signalInfo == "disabled" {
                self.disabledButton()
            }
        })
        
        Database.database().reference().child("signals").observe(.childRemoved) { (_) -> Void in
            self.enabledButton()
        }
    }
    
    func singnal() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
        let id = dateFormatter.string(from: date)
        
        Database.database().reference().child("signals").child(id).setValue(Auth.auth().currentUser?.uid) { (err, _) in
            if let err = err {
                print(err.localizedDescription)
            }
            
            self.youSignalled()
        }
    }
    
    func youSignalled() {
        self.isEnabled = false
        self.bgColor = .orange
    }
    
    func teamSignalled() {
        self.isEnabled = false
        self.bgColor = .yellow
    }
    
    func disabledButton() {
        self.isEnabled = false
        self.bgColor = .gray
    }
    
    func enabledButton() {
        self.isEnabled = true
        self.bgColor = .green
    }
    
    func reset() {
        Database.database().reference().child("signals").removeValue()
    }
    
    func disable() {
        let disableSignal = ["admin" : "disabled"]
        Database.database().reference().child("signals").setValue(disableSignal)
    }
    
}
