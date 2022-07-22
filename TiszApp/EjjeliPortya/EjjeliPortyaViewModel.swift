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
    
    init?(snapshot: DataSnapshot?) {
        guard
            let value = snapshot?.value as? [String: AnyObject],
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
    
    init(id: String?, coordinate: CLLocationCoordinate2D, tint: Color) {
        self.id = id ?? UUID().description
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
    
    @Published var tiszapuspoki_coords = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.221822, longitude: 20.307533), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
    
    @Published var showAlert: Bool = false
    
    @Published var alertType: LocationAlertMessage = .na
    
    @Published var markers: [Marker] = []
    
    @Published var isSharing: Bool = false
    
    private var colors: [Color] = [Color](repeating: .blue, count: 8)
    
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
        Database.database().reference().child("ejjeli_porty_locs").child(String(sessionService?.userDetails?.groupNumber ?? -1)).child(sessionService?.userDetails?.uid ?? "error_noUidInfo").setValue(locationData)
    }
    
    func startLocationSharing() {
        locationManager?.startUpdatingLocation()
        locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    func stopLocationSharing() {
        locationManager?.stopUpdatingLocation()
        self.isSharing = false
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.isSharing = true
        let last = locations.last
        //print("l: \(last?.coordinate.latitude) lo:\(last?.coordinate.longitude)")
        let locationData = ["lat" : last?.coordinate.latitude ?? 0,
                            "long" : last?.coordinate.longitude ?? 0] as [String: Any]
        Database.database().reference().child("ejjeli_porty_locs").child(String(sessionService?.userDetails?.groupNumber ?? -1)).child(sessionService?.userDetails?.uid ?? "error_noUidInfo").setValue(locationData)
    }
    
    func getColors() {
        Database.database().reference().child("colors").observe(.childAdded, with: { [self] (snapshot) -> Void in
            if let colors = ColorList(snapshot: snapshot) {
                self.colors.removeAll()
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
        let orange = "#FF9200"
        let blue = "#0000FF"
        let green = "#00FF00"
        let yellow = "#FFFF00"
        let red = "#FF0000"
        let purple = "#960096"
        let cyan = "#00FFFF"
        let magenta = "#FF00FF"
        
        var colors : [String] = []
        colors.append(orange)
        colors.append(blue)
        colors.append(green)
        colors.append(yellow)
        colors.append(red)
        colors.append(purple)
        colors.append(cyan)
        colors.append(magenta)
        
        Database.database().reference().child("colors").child("colors").setValue(colors)
    }
    
    private func getMarkers() {
        
        self.getColors()
        
        Database.database().reference().child("ejjeli_porty_locs").observe(.childAdded, with: { (snapshot) -> Void in

            let groupNum = Int(snapshot.key) ?? 0

            for children in snapshot.children {
                let child = (children as? DataSnapshot)

                let locData = LocationData(snapshot: child)
                let coords = CLLocationCoordinate2D(latitude: locData?.lat ?? 0.00, longitude: locData?.long ?? 0.00)

                let marker = Marker(id: child?.key, coordinate: coords, tint: self.colors[groupNum])

                self.markers.append(marker)
            }
        })
        
        Database.database().reference().child("ejjeli_porty_locs").observe(.childChanged, with: { (snapshot) -> Void in
            for children in snapshot.children {
                let child = (children as? DataSnapshot)
                
                let locData = LocationData(snapshot: child)
                let coords = CLLocationCoordinate2D(latitude: locData?.lat ?? 0.00, longitude: locData?.long ?? 0.00)
                
                //find old one
                if let marker_index = self.markers.firstIndex(where: {$0.id == child?.key}) {
                    //change to new
                    self.markers[marker_index].coordinate = coords
                } else {
                    let groupNum = Int(snapshot.key) ?? 0
                    let marker = Marker(id: child?.key, coordinate: coords, tint: self.colors[groupNum])
                    self.markers.append(marker)
                }
            }
        })
    }
    
}
