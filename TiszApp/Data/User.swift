//
//  User.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 25..
//

import Foundation

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
