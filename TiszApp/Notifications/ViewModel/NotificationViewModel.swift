//
//  NotificationViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 18..
//

import Foundation
import Firebase

final class NotificationViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var message: String = ""
    
    private var tokenList = [String]()
    
    private var tokenListUser = [String]()
    private var tokenListAdmin = [String]()

    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isShowing = false
    
    init() {
        self.getAllTokens()
        self.getTokensSeparate()
    }
    
    func getTokensSeparate() {
        Database.database().reference().child("deviceTokens").observe(.childAdded, with: { (snapshot) in
            let token = Token(snapshot: snapshot)
            Database.database().reference().child("users").child(snapshot.key).observe(DataEventType.value, with: { snap in
                let user = User(snapshot: snap)
                Messaging.token(Messaging.messaging()) (completion: { t, e in
                    if let t = t {
                        if user?.admin ?? false {
                            if !self.tokenListAdmin.contains(token?.token ?? "") && t != token?.token ?? "" {
                                self.tokenListAdmin.append(token?.token ?? "")
                            }
                        } else {
                            if !self.tokenListUser.contains(token?.token ?? "") && t != token?.token ?? "" {
                                self.tokenListUser.append(token?.token ?? "")
                            }
                        }
                    }
                    
                })
                
            })
        })
    }
    
    func getAllTokens() {
        Database.database().reference().child("deviceTokens").observe(.childAdded, with: { (snapshot) in
            let token = Token(snapshot: snapshot)
            Messaging.token(Messaging.messaging()) (completion: { t, e in
                if let t = t {
                    if !self.tokenList.contains(token?.token ?? "") && t != token?.token ?? "" {
                        self.tokenList.append(token?.token ?? "")
                    }
                }
            })
            
        })
    }
    
    func sendNotification(toUsers: Bool, toAdmins: Bool) {
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else {
            print("url hiba")
            alertTitle = "Hiba"
            alertMessage = "Hiba van az URL-lel."
            isShowing = true
            return
        }
        
        var list : [String] = [""]
        if toUsers && !toAdmins {
            list = self.tokenListUser
        }
        if !toUsers && toAdmins {
            list = self.tokenListAdmin
        }
        if toUsers && toAdmins {
            list = self.tokenList
        }
        
        //print(list)

        Database.database().reference().child("messagingKey").getData { error, snapshot in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertTitle = "Hiba"
                    self.alertMessage = "Hiba van a kulccsal: \(error.localizedDescription)"
                    self.isShowing = true
                }
                return
            }

            if list.count > 0 {
                for i in 0...list.count-1 {
                    let json: [String: Any] = [
                        "to": list[i],
                        "notification": [
                            "title": self.title,
                            "body": self.message
                        ]
                    ]

                    guard let value = snapshot.value as? [String: String],
                          let serverKey = value["key"] else {
                        print("key reading not working")
                        return
                    }

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])

                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")

                    let session = URLSession(configuration: .default)

                    session.dataTask(with: request, completionHandler: { _, _, err in
                        if let err = err {
                            print("ertesites kuldes (legacy) hiba: \(err.localizedDescription)")
                            DispatchQueue.main.async {
                                self.alertTitle = "Hiba"
                                self.alertMessage = "Hiba van a szerverrel: \(err.localizedDescription)"
                                self.isShowing = true
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            self.title = ""
                            self.message = ""
                            self.alertTitle = "Siker"
                            self.alertMessage = "Értesítés kiküldve!"
                            self.isShowing = true
                        }
                    })
                    .resume()
                }
            }
        }
    }
}
