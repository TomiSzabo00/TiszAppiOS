//
//  TreasureHuntViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 26..
//

import Foundation
import FirebaseDatabase

struct TreasureToggle: Identifiable, Hashable {
    let id = UUID()
    var state: Bool = false
    
    init(state: Bool = false) {
        self.state = state
    }
}

final class TreasureHuntViewModel : ObservableObject {
    
    var sessionService: SessionServiceImpl!
    
    @Published var toggles = [TreasureToggle]()
    
    func initToggles() {
        Database.database().reference().child("wordle").observe(.childAdded, with: { (snapshot) in
            if snapshot.key == "treasureHunt" {
                for child in snapshot.children {
                    let number = (child as? DataSnapshot)?.value as? NSNumber ?? 0
                    let shouldBeBool = Bool(truncating: number)
                    
                    if self.toggles.count <= self.sessionService.teamNum {
                        self.toggles.append(TreasureToggle(state: shouldBeBool))
                    }
                }
            }
        })
        
        Database.database().reference().child("wordle").observe(.childChanged, with: { (snapshot) in
            if snapshot.key == "treasureHunt" {
                self.toggles.removeAll()
                for child in snapshot.children {
                    let number = (child as? DataSnapshot)?.value as? NSNumber ?? 0
                    let shouldBeBool = Bool(truncating: number)
                    
                    if self.toggles.count <= self.sessionService.teamNum {
                        self.toggles.append(TreasureToggle(state: shouldBeBool))
                    }
                }
            }
        })
    }
    
    func refreshStates() {
        
        var states = [Bool]()
        for i in self.toggles {
            states.append(i.state)
        }
        
        Database.database().reference().child("wordle").child("treasureHunt").setValue(states)
    }
    
}
