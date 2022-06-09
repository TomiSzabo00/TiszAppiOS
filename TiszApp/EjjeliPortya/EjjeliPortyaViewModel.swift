//
//  EjjeliPortyaViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 08..
//

import Foundation
import MapKit
import FirebaseDatabase
import SwiftUI

enum LocationAlertMessage {
    case na
    case disabled
    case restricted
    case denied
}

struct LocationData {
    var lat: Double
    var long: Double
    
    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let lat = value["lat"] as? Double,
            let long = value["long"] as? Double
        else {
            return nil
        }
        
        self.lat = lat
        self.long = long
    }
}

struct Marker: Identifiable {
    
    var id: String
    var coordinate : CLLocationCoordinate2D
    var tint: Color
    
    init(id: String, coordinate: CLLocationCoordinate2D, tint: Color) {
        self.id = id
        self.coordinate = coordinate
        self.tint = tint
    }
}

struct ColorList: Decodable {
    var colors: [String]
    
    init(colors: [String]) {
        self.colors = colors
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String]
            //let colors = value["colors"] as? [String]
        else {
            return nil
        }
        self.colors = value
    }
}

final class EjjeliPortyaViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var sessionService: SessionServiceImpl?
    
    var locationManager: CLLocationManager?
    
    @Published var tiszapuspoki_coords = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.222073, longitude: 20.296315), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @Published var showAlert: Bool = false
    
    @Published var alertType: LocationAlertMessage = .na
    
    @Published var markers: [Marker] = []
    
    private var colors: [Color] = []
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager?.activityType = .fitness

            self.getMarkers()
        } else {
            //alert: its off, turn it on
            alertType = .disabled
            showAlert = true
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //alert: parental controls disabled location services
            alertType = .restricted
            showAlert = true
            break
        case .denied:
            //alert: disabled by user
            alertType = .denied
            showAlert = true
            break
        case .authorizedAlways, .authorizedWhenInUse:
            //users location: locationManager.location?.coordinate
            break
        @unknown default:
            alertType = .na
            showAlert = true
        }
    }
    
    func uploadLocationOnce() {
        let locationData = ["lat" : locationManager?.location?.coordinate.latitude ?? 0.00,
                            "long" : locationManager?.location?.coordinate.longitude ?? 0.00] as [String: Any]
        Database.database().reference().child("portya_locs").child(String(sessionService!.userDetails!.groupNumber)).child(sessionService!.userDetails!.uid).setValue(locationData)
    }
    
    func startLocationSharing() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopLocationSharing() {
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let last = locations.last
        //print("l: \(last?.coordinate.latitude) lo:\(last?.coordinate.longitude)")
        let locationData = ["lat" : last!.coordinate.latitude,
                            "long" : last!.coordinate.longitude] as [String: Any]
        Database.database().reference().child("portya_locs").child(String(sessionService!.userDetails!.groupNumber)).child(sessionService!.userDetails!.uid).setValue(locationData)
    }
    
    func getColors() {
        Database.database().reference().child("colors").observe(.childAdded, with: { [self] (snapshot) -> Void in            if let colors = ColorList(snapshot: snapshot) {
                for color in colors.colors {
                    self.colors.append(hexStringToColor(hex: color))
                }
            }
        })
    }
    
    private func hexStringToColor (hex:String) -> Color {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return Color.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return Color(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0
        )
    }
    
    func uploadColorsToDB() {
        let blue = "#0000FF"
        let green = "#00FF00"
        let yellow = "#FFFF00"
        let red = "#FF0000"
        let purple = "#960096"
        let cyan = "#00FFFF"
        let orange = "#FF9200"
        let magenta = "#FF00FF"
        
        var colors : [String] = []
        colors.append(blue)
        colors.append(green)
        colors.append(yellow)
        colors.append(red)
        colors.append(purple)
        colors.append(cyan)
        colors.append(orange)
        colors.append(magenta)
        
        Database.database().reference().child("colors").child("colors").setValue(colors)
    }
    
    private func getMarkers() {
        
        self.getColors()
        
        Database.database().reference().child("portya_locs").observe(.childAdded, with: { (snapshot) -> Void in
            
            let groupNum = Int(snapshot.key)
            
            for children in snapshot.children {
                let child = (children as! DataSnapshot)
                
                let locData = LocationData(snapshot: child)
                let coords = CLLocationCoordinate2D(latitude: locData?.lat ?? 0.00, longitude: locData?.long ?? 0.00)
                
                let marker = Marker(id: child.key, coordinate: coords, tint: self.colors[groupNum!])
                
                //markerList.append(marker)
                self.markers.append(marker)
                print(marker.coordinate)
                //print("marker placed")
            }
        })
        
        //self.markers = markerList
        
        
//        Database.database().reference().child("scores").observe(.childChanged, with: { (snapshot) -> Void in
//               if let score = ScoreItem(snapshot: snapshot) {
//                //find old one
//                let oldScore = self.scoresList[self.scoresList.firstIndex(where: {$0.id == score.id})!]
//                   for i in 0...self.teamNum-1 {
//                       guard oldScore.scores.indices.contains(i) else { return }
//                       self.sums[i] -= oldScore.scores[i]
//                   }
//
//                //change to new
//               self.scoresList[self.scoresList.firstIndex(where: {$0.id == score.id})!] = score
//                   for i in 0...self.teamNum-1 {
//                       guard score.scores.indices.contains(i) else { return }
//                       self.sums[i] += score.scores[i]
//                   }
//            }
//
//        })
    }
    
}
