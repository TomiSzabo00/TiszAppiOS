//
//  RegistrationService.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 27..
//

import Foundation
import Combine
import FirebaseDatabase
import FirebaseAuth

protocol RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            
            Future { promise in
                
                Auth.auth().createUser(withEmail: details.userName+"tiszap.hu", password: details.password, completion: { res, error in
                    
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        //User created
                        if let uid = res?.user.uid {
                            
                            let userDetails = [UserKeys.userName.rawValue : details.fullName,
                                               UserKeys.groupNumber.rawValue : 99,
                                               UserKeys.admin.rawValue : false,
                                               UserKeys.uid.rawValue : uid] as [String : Any]
                            
                            Database.database().reference().child("users").child(uid).setValue(userDetails) {
                                error, ref in
                                if let err = error {
                                    promise(.failure(err))
                                } else {
                                    promise(.success(()))
                                }
                            }
                            
                        } else {
                            promise(.failure(NSError(domain: "UID invalid", code: 0)))
                        }
                        
                    }
                })
                
            }
            
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
