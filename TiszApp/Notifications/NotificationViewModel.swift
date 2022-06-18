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
    
    init() {
        Database.database().reference().child("deviceTokens").observe(.childAdded, with: { (snapshot) in
            let token = Token(snapshot: snapshot)
            self.tokenList.append(token?.token ?? "")
        })
    }
    
    func sendNotification() {
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else {
            print("url hiba")
            return
        }
        
        for i in 0...self.tokenList.count-1 {
        
            let json: [String: Any] = [
                "to": tokenList[i],
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
                print("kikuldve!")
            })
            .resume()
        }
    }
}
