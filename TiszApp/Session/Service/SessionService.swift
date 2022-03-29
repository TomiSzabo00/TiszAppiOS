//
//  SessionService.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 27..
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

enum SessionState {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails? { get }
    var buttonTitles: [String] { get }
    var buttonIcons: [String] { get }
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
    @Published var buttonTitles: [String] = ["Feltöltés", "Pontállás", "Sportok", "AV Kvíz", "Képek megtekintése", "Szövegek megtekintése"]
    @Published var buttonIcons: [String] = ["square.and.arrow.up.fill", "chart.bar.xaxis", "flowchart", "play.rectangle.fill", "eye.fill", "eye.fill"]
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFirebaseAuthHandler()
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
}

private extension SessionServiceImpl {
    func setupFirebaseAuthHandler() {
        handler = Auth.auth().addStateDidChangeListener {
            [weak self] res, user in
            guard let self = self else { return }
            self.state = user == nil ? .loggedOut : .loggedIn
            
            if let uid = user?.uid {
                self.handleRefresh(with: uid)
            }
        }
    }
    
    func handleRefresh(with uid: String) {
        Database.database().reference().child("users").child(uid).observe(.value) {
            [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? NSDictionary,
                  let fullName = value[UserKeys.userName.rawValue] as? String,
                  let groupNumber = value[UserKeys.groupNumber.rawValue] as? Int,
                  let admin = value[UserKeys.admin.rawValue] as? Bool,
                  let uuid = value[UserKeys.uid.rawValue] as? String else {
                return
            }
            
            DispatchQueue.main.async {
                self.userDetails = SessionUserDetails(fullName: fullName, groupNumber: groupNumber, admin: admin, uid: uuid)
                self.buttonTitles = ["Feltöltés", "Pontállás", "Sportok", "AV Kvíz", "Képek megtekintése", "Szövegek megtekintése"]
                self.buttonIcons = ["square.and.arrow.up.fill", "chart.bar.xaxis", "flowchart", "play.rectangle.fill", "eye.fill", "eye.fill"]
                if self.userDetails?.admin == true {
                    self.buttonTitles += ["Képek ellenőrzése", "Pontok feltöltése"]
                    self.buttonIcons += ["eye.fill", "plus.square.fill"]
                }
            }
            
        }
    }
}
