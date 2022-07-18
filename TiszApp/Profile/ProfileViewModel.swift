//
//  ProfileViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 16..
//

import Foundation
import FirebaseDatabase

struct SimpleUser: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var teammates: [SimpleUser]?
}

final class ProfileViewModel: ObservableObject {
    
    var groupNum : Int
    var name : String
    
    @Published var user = [SimpleUser]()
    
    init(groupNum: Int, name: String) {
        self.groupNum = groupNum
        self.name = name
        
        self.user.append(SimpleUser(name: "Regisztrált csapattagok"))
        self.user[0].teammates = []
    }
    
    func getTeammates() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let user = User(snapshot: snapshot) {
                if user.groupNumber == self.groupNum && user.userName != self.name {
                    self.user[0].teammates?.append(SimpleUser(name: user.userName))
                }
            }
        })
    }
    
}
