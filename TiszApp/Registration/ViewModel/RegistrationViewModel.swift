//
//  RegistrationViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 27..
//

import Foundation
import Combine

enum RegistrationState {
    case successfull
    case failed(error: Error)
    case na
}

enum AuthErrorType {
    case noMatchingPasswords
    case noFullNameInDatabase
    case noMatchingNameAndID
    case na
}

protocol RegistrationViewModel {
    func register()
    var service: RegistrationService { get }
    var state: RegistrationState { get }
    var hasError: Bool { get }
    var userDetails: RegistrationDetails { get set }
    var errorType: AuthErrorType { get }
    init(service: RegistrationService)
}

final class RegistrationViewModelImpl: ObservableObject, RegistrationViewModel {
    @Published var errorType: AuthErrorType = .na
    @Published var hasError: Bool = false
    @Published var state: RegistrationState = .na
    @Published var userDetails: RegistrationDetails = RegistrationDetails.new

    var service: RegistrationService
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: RegistrationService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    func register() {
        
        //persons full name must be in database
                guard service.allUserNames.contains(userDetails.fullName) else {
                    hasError = true
                    errorType = .noFullNameInDatabase
                    return
                }
        
        //persons full name and id must match
                guard fullNameHasMatchingID(name: userDetails.fullName, id: userDetails.id) else {
                    hasError = true
                    errorType = .noMatchingNameAndID
                    return
                }
        
        //passwords must match
        guard userDetails.password == userDetails.password2 else {
            hasError = true
            errorType = .noMatchingPasswords
            return
        }
        
        //all conditions have been met
        errorType = .na
        service.register(with: userDetails)
            .sink { [weak self] result in
                
                switch result {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
                
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscriptions)
    }
}

private extension RegistrationViewModelImpl {
    func setupErrorSubscriptions() {
        $state
            .map { state -> Bool in
                switch state {
                case .successfull,
                        .na:
                    return false
                case .failed:
                    return true
                }
                
            }
            .assign(to: &$hasError)
    }
}

private extension RegistrationViewModelImpl {
    func fullNameHasMatchingID(name: String, id: String) -> Bool {
        
        let filterFromAdmins = service.adminUsers.filter { $0.0 == name && $0.1 == Int(id) }
        for admin in filterFromAdmins {
            service.filteredUser = RegisterInfo(fullName: admin.0, groupNumber: 0, admin: true)
            return true
        }
        
        let filterFromUsers = service.simpleUsers.filter { $0.0 == name && $0.1 == Int(id) }
        for user in filterFromUsers {
            service.filteredUser = RegisterInfo(fullName: user.0, groupNumber: user.2, admin: false)
            return true
        }
        
        return false
    }
}
