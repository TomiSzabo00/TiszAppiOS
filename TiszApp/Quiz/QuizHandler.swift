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
    var texts: [String] { get }
    var textColors: [Color] { get }
    var rtBGs: [BackroundStyle] { get }
    var teamNum: Int { get set }
    func teamSignalled()
    func disabledButton()
    func enabledButton()
    func initListeners()
    func reset()
    func disable()
}

final class QuizHandlerImpl : QuizHandler, ObservableObject {
    
    @Published var teamNum: Int = 6
    
    @Published var isEnabled: Bool = true
    @Published var bgColor: Color = .green
    
    @Published var userDetails: SessionUserDetails? = nil
    
    @Published var texts: [String] = []
    
    @Published var textColors: [Color] = []
    
    @Published var rtBGs: [BackroundStyle] = []
    
    private var nextTextNum: Int = 0
    
    private var teamSignals: [Int] = []
    
    init() {
        for i in 0...teamNum {
            self.texts.append("Nincs \(i+1). jelentkező")
            self.textColors.append(Color.accentColor)
            self.rtBGs.append(.normal)
        }
    }
    
    func initListeners() {
        Database.database().reference().child("signals").observe(.childAdded, with: { (snapshot) -> Void in
            
            let signalInfo = snapshot.value as? String
            

            if signalInfo == "disabled" {
                self.disabledButton()
                
                for i in 0...self.teamNum-1 {
                    self.texts[i] = "Letiltva"
                    self.textColors[i] = Color.accentColor
                    self.rtBGs[i] = .gray
                }
                
            } else {
                    Database.database().reference().child("users").child(signalInfo ?? "error_noSignalInfo").observe(DataEventType.value, with: { snapshot in
                        let author = User(snapshot: snapshot)
                
                        if(!self.teamSignals.contains(author?.groupNumber ?? -1)) {
                            if author?.groupNumber == self.userDetails?.groupNumber {
                                self.teamSignalled()
                            }
                            self.teamSignals.append(author?.groupNumber ?? -1)
                            self.texts[self.nextTextNum] = "\(author?.groupNumber ?? -1). csapat (\(author?.userName ?? "error"))"
                            self.rtBGs[self.nextTextNum] = .color
                            self.textColors[self.nextTextNum] = .text
                            self.nextTextNum += 1
                        }
                      })
            }
        })
        
        Database.database().reference().child("signals").observe(.childRemoved) { (_) -> Void in
            self.enabledButton()
            self.reset()
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
            
            self.teamSignalled()
        }
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
        
        for i in 0...teamNum-1 {
            self.texts[i] = "Nincs \(i+1). jelentkező"
            self.textColors[i] = Color.accentColor
            self.rtBGs[i] = .normal
        }
        self.teamSignals.removeAll()
        self.nextTextNum = 0
    }
    
    func disable() {
        let disableSignal = ["admin" : "disabled"]
        Database.database().reference().child("signals").setValue(disableSignal)
        
        for i in 0...self.teamNum-1 {
            self.texts[i] = "Letiltva"
            self.textColors[i] = .white
            self.rtBGs[i] = .gray
        }
    }
    
}
