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

struct UserInfo: Decodable {
    var Név: String
    var ID: String
    var Csapat: String
}

struct AdminInfo: Decodable {
    var Név: String
    var ID: String
}

struct RegisterInfo {
    var fullName: String
    var groupNumber: Int
    var admin: Bool
}

extension RegisterInfo {
    static var new: RegisterInfo {
        RegisterInfo(fullName: "", groupNumber: -1, admin: false)
    }
}

protocol RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error>
    func getAdminNamesAndIDs(completion: @escaping(Result<[AdminInfo], Error>) -> Void)
    func getUserNamesAndIDs(completion: @escaping(Result<[UserInfo], Error>) -> Void)
    var isloading: Bool { get }
    var simpleUsers: [(String, Int, Int, Bool)] { get }
    var adminUsers: [(String, Int, Int, Bool)] { get }
    var allUserNames: Array<String> { get set }
    var filteredUser: RegisterInfo { get set }
}

final class RegistrationServiceImpl: RegistrationService {
    @Published var isloading: Bool = false
    @Published var simpleUsers: [(String, Int, Int, Bool)] = []
    @Published var adminUsers: [(String, Int, Int, Bool)] = []
    @Published var allUserNames: Array<String> = []
    @Published var filteredUser: RegisterInfo = RegisterInfo.new
    
    init() {
        self.getAdminNamesAndIDs { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let admins):
                for admin in admins {
                    self?.adminUsers.append((admin.Név, Int(admin.ID) ?? -1, 0, true))
                    self?.allUserNames.append(admin.Név)
                }
                self?.isloading = false
            }
        }
        
        self.getUserNamesAndIDs { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let users):
                for user in users {
                    self?.simpleUsers.append((user.Név, Int(user.ID) ?? -1 , Int(user.Csapat) ?? -1, false))
                    self?.allUserNames.append(user.Név)
                }
                self?.allUserNames = Array(Set(self?.allUserNames ?? ["üres"]))
                self?.isloading = false
            }
        }
    }
    
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            
            Future { promise in
                
                Auth.auth().createUser(withEmail: details.userName+"@tiszap.hu", password: details.password, completion: { [self] res, error in
                    
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        //User created
                        if let uid = res?.user.uid {
                            
                            let userDetails = [UserKeys.userName.rawValue : self.filteredUser.fullName,
                                               UserKeys.groupNumber.rawValue : self.filteredUser.groupNumber,
                                               UserKeys.admin.rawValue : self.filteredUser.admin,
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
    
    func getAdminNamesAndIDs(completion: @escaping(Result<[AdminInfo], Error>) -> Void) {
        self.isloading = true
        //use API to get arrays
        let adminURLstring = "https://opensheet.elk.sh/10JPtOuuQAMpGmorEHFW_yU-M2M99AAhpZn09CRcGPK4/admins"
        
        guard let urlAdmin = URL(string: adminURLstring) else {
            print("admin url not working")
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
                let admins = try decoder.decode([AdminInfo].self, from: data)
                completion(.success(admins))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
        adminJSONtask.resume()
    }
    
    func getUserNamesAndIDs(completion: @escaping(Result<[UserInfo], Error>) -> Void) {
        self.isloading = true
        //use API to get arrays
        let userURLstring = "https://opensheet.elk.sh/10JPtOuuQAMpGmorEHFW_yU-M2M99AAhpZn09CRcGPK4/users"
        
        guard let urlUser = URL(string: userURLstring) else {
            print("user url not working")
            fatalError()
        }
        
        let userJSONtask = URLSession.shared.dataTask(with: urlUser){
            data, response, error in
            
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            do {
                let decoder = JSONDecoder()
                let users = try decoder.decode([UserInfo].self, from: data)
                completion(.success(users))
            } catch {
                print(error)
                completion(.failure(error))
            }
            
        }
        userJSONtask.resume()
    }
}
