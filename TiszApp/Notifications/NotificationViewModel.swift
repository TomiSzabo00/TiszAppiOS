//
//  NotificationViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 18..
//

import Foundation
import Firebase

struct Token: Decodable {
    var token: String
    
    init(token: String) {
        self.token = token
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: String],
            let token = value["token"]
        else {
            return nil
        }
        
        self.token = token
    }
}

final class NotificationViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var message: String = ""
    
    private var tokenList = [String]()
    
    private var tokenListUser = [String]()
    private var tokenListAdmin = [String]()
    
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
        
        print(list)
        
        if list.count > 0 {
            for i in 0...list.count-1 {
                print("heo")
                let json: [String: Any] = [
                    "to": list[i],
                    "notification": [
                        "title": self.title,
                        "body": self.message
                    ]
                ]
                
                let notServerKey = "AAAAo-Pv9cM:APA91bGn3FwMHepePdM7GGNcAL1VJbvaev_yHPGZY-FjLsASeukqwk9dbD6U-3rM29w_9CfOjfT9xRxjFrGtEQA4TwyX4GxxBmJsC8kQNz7ISDxxVUAmJJewtUAEB0UJvfzJJNnczSOg"
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("key=\(notServerKey)", forHTTPHeaderField: "Authorization")
                
                let session = URLSession(configuration: .default)
                
                session.dataTask(with: request, completionHandler: { _, _, err in
                    if let err = err {
                        print("ertesites kuldes (legacy) hiba: \(err.localizedDescription)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.title = ""
                        self.message = ""
                    }
                    //print("kikuldve!")
                })
                .resume()
            }
        }
    }
}
