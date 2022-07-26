//
//  NappaliPortyaViewModel.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 26..
//

import Foundation
import FirebaseDatabase

final class NappaliPortyaViewModel: ObservableObject {
    @Published var links = [URL]()

    init() {
        getLinks()
    }

    func getLinks() {
        Database.database().reference().child("porty_drive_links").observe(.childAdded) { snapshot in
            let urlString = snapshot.value as? String ?? ""
            if let url = URL(string: urlString) {
                print(url)
                self.links.append(url)
            }
        }
    }
}
