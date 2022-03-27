//
//  LoginViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 27..
//

import Foundation
import Combine

enum LoginState {
    case successfull
    case failed(error: Error)
    case na
}

protocol LoginViewModel {
    func login()
    var service: LoginService { get }
    var state: LoginState { get }
    var details: LoginDetails { get }
    init(service: LoginService)
}

final class LoginViewModelImpl: ObservableObject, LoginViewModel {
    
    @Published var details: LoginDetails = LoginDetails.new
    @Published var state: LoginState = .na
    
    let service: LoginService
    
    private var subscriptions = Set<AnyCancellable>()
    
    func login() {
        service
            .login(with: details)
            .sink { result in
                
                switch result {
                case .failure(let err):
                    self.state = .failed(error: err)
                default: break
                }
                
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscriptions)
    }
    
    init(service: LoginService) {
        self.service = service
    }
    
    
}
