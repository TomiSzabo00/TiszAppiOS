//
//  LoginService.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 27..
//

import Foundation
import Combine
import FirebaseAuth

protocol LoginService {
    func login(with details: LoginDetails) -> AnyPublisher<Void, Error>
}

final class LoginServiceImpl: LoginService {
    func login(with details: LoginDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            
            Future { promise in
                Auth.auth().signIn(withEmail: details.userName+"@tiszap.hu", password: details.password) {
                    res, error in
                    
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        promise(.success(()))
                    }
                }
            }
            
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
