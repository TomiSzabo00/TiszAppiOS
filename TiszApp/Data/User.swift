//
//  User.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 25..
//

import Foundation
import FirebaseDatabase

struct User {
    var userName: String        //user's full name
    var groupNumber: Int        //user's group number (1-4)
    var admin: Bool             //is user admin
    var uid: String             //registration uid (firebase)
    
    init(userName: String, groupNumber: Int, admin: Bool, uid: String){
        self.userName = userName
        self.groupNumber = groupNumber
        self.admin = admin
        self.uid = uid
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let userName = value["userName"] as? String,
            let groupNumber = value["groupNumber"] as? Int,
            let admin = value["admin"] as? Bool,
            let uid = value["uid"] as? String
        else {
            return nil
        }
        
        self.userName = userName
        self.groupNumber = groupNumber
        self.admin = admin
        self.uid = uid
    }
}

struct RegistrationDetails {
    var userName: String
    var password: String
    var password2: String
    var fullName: String
    var id: String
}

extension RegistrationDetails {
    static var new: RegistrationDetails {
        RegistrationDetails(userName: "", password: "", password2: "", fullName: "", id: "")
    }
}

struct LoginDetails {
    var userName: String
    var password: String
}

extension LoginDetails {
    static var new: LoginDetails {
        LoginDetails(userName: "", password: "")
    }
}

enum UserKeys : String {
    case userName       //user's full name
    case groupNumber    //user's group number (1-4)
    case admin          //is user admin
    case uid            //registration uid (firebase)
}
