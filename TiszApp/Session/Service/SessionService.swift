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
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
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
            }
            
        }
    }
}
