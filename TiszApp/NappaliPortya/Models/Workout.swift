//
//  Workout.swift
//  MyMap
//
//  Created by Finnis on 15/05/2021.
//

import Foundation
import MapKit
import CoreLocation
import FirebaseDatabase

struct Workout: Equatable {
    let routeLocations: [CLLocation]
    let teamNUm: Int

    func toDictionary() -> [String: Any] {
        let locs = self.routeLocations.map { location in
            ["lat" : location.coordinate.latitude,
             "long" : location.coordinate.longitude] as [String: Any]
        }
        return ["routeLocations" : locs,
                "team" : teamNUm] as [String: Any]
    }

    init(snapshot: DataSnapshot) {
        //self.routeLocations = .init()
        self.teamNUm = Int(snapshot.key) ?? 0
        self.routeLocations = snapshot.children.map { loc in
            if let value = (loc as? DataSnapshot)?.value as? [String: Double] {
                let lat = value["lat"] ?? 0
                let long = value["long"] ?? 0
                return CLLocation(latitude: lat, longitude: long)
            }
            print("hiba lokacioknal")
            return CLLocation(latitude: 0.0, longitude: 0.0)
        }
//        snapshot.children.forEach { loc in
//            if let value = (loc as? DataSnapshot)?.value as? [String: Double] {
//                let lat = value["lat"] ?? 0
//                let long = value["long"] ?? 0
//                self.routeLocations.append(CLLocation(latitude: lat, longitude: long))
//            }
//        }
    }
}
