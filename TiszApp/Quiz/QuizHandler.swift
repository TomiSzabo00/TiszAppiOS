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
    var text0Color: Color { get }
    var text1Color: Color { get }
    var text2Color: Color { get }
    var text3Color: Color { get }
    var rt0BG: BackroundStyle { get }
    var rt1BG: BackroundStyle { get }
    var rt2BG: BackroundStyle { get }
    var rt3BG: BackroundStyle { get }
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
    
    @Published var texts: [String] = ["Nincs első jelentkező.", "Nincs második jelentkező.", "Nincs harmadik jelentkező.", "Nincs negyedik jelentkező."]
    
    @Published var text0Color = Color.foreground
    @Published var text1Color = Color.foreground
    @Published var text2Color = Color.foreground
    @Published var text3Color = Color.foreground
    
    @Published var rt0BG: BackroundStyle = .normal
    @Published var rt1BG: BackroundStyle = .normal
    @Published var rt2BG: BackroundStyle = .normal
    @Published var rt3BG: BackroundStyle = .normal
    
    private var nextTextNum: Int = 0
    
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
                
                self.texts = ["Letiltva", "Letiltva", "Letiltva", "Letiltva"]
                
                self.text0Color = .white
                self.text1Color = .white
                self.text2Color = .white
                self.text3Color = .white
                
                self.rt0BG = .gray
                self.rt1BG = .gray
                self.rt2BG = .gray
                self.rt3BG = .gray
                
            } else {
                switch self.nextTextNum {
                case 0:
                    self.rt0BG = .color
                    self.text0Color = .white
                    Database.database().reference().child("users").child(signalInfo).observe(DataEventType.value, with: { snapshot in
                        let author = User(snapshot: snapshot)
                        self.texts[0] = "\(author!.groupNumber). csapat (\(author!.userName))"
                      })
                    self.nextTextNum += 1
                case 1:
                    self.rt1BG = .color
                    self.text1Color = .white
                    Database.database().reference().child("users").child(signalInfo).observe(DataEventType.value, with: { snapshot in
                        let author = User(snapshot: snapshot)
                        self.texts[1] = "\(author!.groupNumber). csapat (\(author!.userName))"
                      })
                    self.nextTextNum += 1
                case 2:
                    self.rt2BG = .color
                    self.text2Color = .white
                    Database.database().reference().child("users").child(signalInfo).observe(DataEventType.value, with: { snapshot in
                        let author = User(snapshot: snapshot)
                        self.texts[2] = "\(author!.groupNumber). csapat (\(author!.userName))"
                      })
                    self.nextTextNum += 1
                case 3:
                    self.rt3BG = .color
                    self.text3Color = .white
                    Database.database().reference().child("users").child(signalInfo).observe(DataEventType.value, with: { snapshot in
                        let author = User(snapshot: snapshot)
                        self.texts[3] = "\(author!.groupNumber). csapat (\(author!.userName))"
                      })
                    self.nextTextNum = 0
                default:
                    self.nextTextNum = 0
                }
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
        self.texts = ["Nincs első jelentkező.", "Nincs második jelentkező.", "Nincs harmadik jelentkező.", "Nincs negyedik jelentkező."]
        
        self.text0Color = Color.foreground
        self.text1Color = Color.foreground
        self.text2Color = Color.foreground
        self.text3Color = Color.foreground
        
        self.rt0BG = .normal
        self.rt1BG = .normal
        self.rt2BG = .normal
        self.rt3BG = .normal
        
        self.nextTextNum = 0
    }
    
    func disable() {
        let disableSignal = ["admin" : "disabled"]
        Database.database().reference().child("signals").setValue(disableSignal)
        
        self.texts = ["Letiltva", "Letiltva", "Letiltva", "Letiltva"]
        
        self.text0Color = .white
        self.text1Color = .white
        self.text2Color = .white
        self.text3Color = .white
        
        self.rt0BG = .gray
        self.rt1BG = .gray
        self.rt2BG = .gray
        self.rt3BG = .gray
    }
    
}
