//
//  TreasureHuntViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 26..
//

import Foundation
import FirebaseDatabase

final class TreasureHuntViewModel : ObservableObject {
    
    var sessionService: SessionServiceImpl!
    
    @Published var toggles = [TreasureToggle]()
    
    func initToggles() {
        Database.database().reference().child("wordle").observe(.childAdded, with: { (snapshot) in
            if snapshot.key == "treasureHunt" {
                self.toggles.removeAll()
                for child in snapshot.children {
                    let number = (child as? DataSnapshot)?.value as? NSNumber ?? 0
                    let shouldBeBool = Bool(truncating: number)

                    self.toggles.append(TreasureToggle(state: shouldBeBool))
                }
            }
        })
        
        Database.database().reference().child("wordle").observe(.childChanged, with: { (snapshot) in
            if snapshot.key == "treasureHunt" {
                self.toggles.removeAll()
                for child in snapshot.children {
                    let number = (child as? DataSnapshot)?.value as? NSNumber ?? 0
                    let shouldBeBool = Bool(truncating: number)

                    self.toggles.append(TreasureToggle(state: shouldBeBool))
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
