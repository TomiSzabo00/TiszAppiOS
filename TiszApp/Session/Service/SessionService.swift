//
//  SessionService.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 27..
//

import Foundation
import Combine
import Firebase
import SwiftUI

enum SessionState {
    case loggedIn
    case loggedOut
}

struct MenuInfo: Decodable {
    var Visible: String
    var Name: String
}

struct TeamNumInfo: Decodable {
    var Num: String
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails? { get }
    var buttonTitles: [String] { get }
    var buttonIcons: [String] { get }
    var btnStates: [Bool] { get }
    var teamNum: Int { get }
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
    @Published var buttonTitles: [String] = ["Feltöltés",
                                             "Pontállás",
                                             "AV Kvíz",
                                             "Képek",
                                             "Szövegek",
                                             "Portya",
                                             "Éjjeli portya",
                                             "Daloskönyv",
                                             "Kvíz 2",
                                             "Wordle",
                                             "Ütemterv",
                                             "Képek ellenőrzése",
                                             "Pontok feltöltése",
                                             "Értesítés",
                                             "Kincskeresés"]
    
    @Published var buttonIcons: [String] = ["square.and.arrow.up.fill", "chart.bar.xaxis", "play.rectangle.fill", "photo.on.rectangle.angled", "doc.text", "figure.walk.diamond.fill", "moon.zzz.fill", "music.note.list", "rectangle.and.pencil.and.ellipsis", "w.square.fill", "calendar", "eye.fill", "plus.square.fill", "exclamationmark.bubble.fill", "map"]

    @Published var btnStates = [Bool]()
    
    @Published var teamNum: Int = 4
    
    @Published var token: String = ""
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.btnStates = [Bool](repeating: false, count: self.buttonTitles.count)
        self.getButtonStates()
        setupFirebaseAuthHandler()
        self.getTeamNum()
    }
    
    func getTeamNum() {
        self.getTeamNumFromApi { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let num):
                DispatchQueue.main.async {
                    self?.teamNum = num
                }
            }
        }
    }
    
    func getButtonStates() {
        var tmp: [Bool] = []
        self.getUserButtons { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let buttons):
                    for btn in buttons {
                        tmp.append(btn.Visible == "1")
                        
                    }
                DispatchQueue.main.async {
                    self?.btnStates = tmp
                }
            }
        }
    }
    
    func logout() {
        Database.database().reference().child("deviceTokens").child(Auth.auth().currentUser?.uid ?? "nil").removeValue()
        try? Auth.auth().signOut()
    }
    
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
                
                Messaging.token(Messaging.messaging()) (completion: { t, e in
                    if let t = t {
                        let deviceToken:[String: String] = ["token": t]
                        Database.database().reference().child("deviceTokens").child(Auth.auth().currentUser?.uid ?? "nil").setValue(deviceToken)
                    }
                })
            }
            
        }
    }
    
    func getUserButtons(completion: @escaping(Result<[MenuInfo], Error>) -> Void) {
        //use API to get arrays
        let adminURLstring = "https://opensheet.elk.sh/10JPtOuuQAMpGmorEHFW_yU-M2M99AAhpZn09CRcGPK4/user_menu"
        
        guard let urlAdmin = URL(string: adminURLstring) else {
            print("userBtn url not working")
            fatalError()
        }
        
        let adminJSONtask = URLSession.shared.dataTask(with: urlAdmin){
            data, response, error in
            
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            do {
                let decoder = JSONDecoder()
                let buttons = try decoder.decode([MenuInfo].self, from: data)
                completion(.success(buttons))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
        adminJSONtask.resume()
    }
    
    func getTeamNumFromApi(completion: @escaping(Result<Int, Error>) -> Void) {
        //use API to get arrays
        let adminURLstring = "https://opensheet.elk.sh/10JPtOuuQAMpGmorEHFW_yU-M2M99AAhpZn09CRcGPK4/team_num"
        
        guard let urlAdmin = URL(string: adminURLstring) else {
            print("teamNum url not working")
            fatalError()
        }
        
        let adminJSONtask = URLSession.shared.dataTask(with: urlAdmin){
            data, response, error in
            
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            do {
                let decoder = JSONDecoder()
                let num = try decoder.decode([TeamNumInfo].self, from: data)
                completion(.success(Int(num[0].Num) ?? 4))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
        adminJSONtask.resume()
    }
}
