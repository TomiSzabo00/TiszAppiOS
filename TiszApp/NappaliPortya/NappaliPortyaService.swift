//
//  NappaliPortyaService.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 15..
//

import Foundation
import FirebaseDatabase
import MapKit

final class NappaliPortyaService: ObservableObject {
    var sessionService: SessionServiceImpl?
    @Published var allCoordinates = [[CLLocationCoordinate2D]]()
    @Published var observedUID = ""

    init(service: SessionServiceImpl?) {
        self.sessionService = service
        
        getPoints()
    }

    func getPoints() {
        for _ in 0...(sessionService?.teamNum ?? 6) {
            allCoordinates.append([CLLocationCoordinate2D]())
        }

        Database.database().reference().child("nappali_porty_locs").observe(.childAdded, with: { (snapshot) -> Void in
            let groupNum = Int(snapshot.key)

            let selectedUid = snapshot.children.max { ($1 as! DataSnapshot).childrenCount > ($0 as! DataSnapshot).childrenCount }

            for coordData in (selectedUid as! DataSnapshot).children {
                let coordData = coordData as! DataSnapshot
                let locData = LocationData(snapshot: coordData)
                let coords = CLLocationCoordinate2D(latitude: locData?.lat ?? 0.00, longitude: locData?.long ?? 0.00)

                self.allCoordinates[groupNum ?? 0].append(coords)
            }
        })

        Database.database().reference().child("nappali_porty_locs").child(String(sessionService?.userDetails?.groupNumber ?? 0))
            .observe(.childChanged) { snapshot in
                let selectedUid = snapshot.children.max { ($1 as! DataSnapshot).childrenCount > ($0 as! DataSnapshot).childrenCount }
                self.observedUID = (selectedUid as! DataSnapshot).key
                Database.database().reference().child("nappali_porty_locs").child(String(self.sessionService?.userDetails?.groupNumber ?? 0)).child(self.observedUID)
                    .observe(.childAdded) { snapshot in
                        let locData = LocationData(snapshot: snapshot)
                        let coords = CLLocationCoordinate2D(latitude: locData?.lat ?? 0.00, longitude: locData?.long ?? 0.00)

                        self.allCoordinates[self.sessionService?.userDetails?.groupNumber ?? 0].append(coords)
                    }
            }
    }
}
