//
//  RegistrationService.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 25..
//

import Foundation
import Combine
import FirebaseDatabase
import FirebaseAuth

enum UserKeys : String {
    case uid
    case userName
    case groupNumber
    case isAdmin
    case fullName
}

protocol RegistrationService {
    func register(with details: UserDetails, with password: String) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: RegistrationService {
    
    func register(with details: UserDetails, with password: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth()
                    .createUser(withEmail: details.userName+"@tiszap.hu", password: password, completion: {res, error in
                    
                    if let err = error{
                        promise(.failure(err))
                    } else {
                        
                        if let uid = res?.user.uid {
                            let values = [UserKeys.userName: details.fullName,
                                          UserKeys.groupNumber: "69",
                                          UserKeys.isAdmin: "false"] as [String : Any]
                            
                            Database.database()
                                .reference().child("users").child(uid).setValue(values)
                            
                            
                        } else {
                            promise(.failure(NSError(domain: "Invalid User ID", code: 0)))
                        }
                        
                    }
                })
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
