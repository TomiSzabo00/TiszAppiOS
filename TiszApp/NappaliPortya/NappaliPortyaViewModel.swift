//
//  NappaliPortyaViewModel.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 14..
//

import Foundation
import MapKit
import FirebaseDatabase
import SwiftUI

final class NappaliPortyaViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var sessionService: SessionServiceImpl?

    private var locationManager: CLLocationManager?

    @Published var tiszapuspokiFaluCoords = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.213725, longitude: 20.318096), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
    @Published var locationRegion: MKCoordinateRegion?
    @Published var trackingMode: MapUserTrackingMode = .follow

    @Published var alertType: LocationAlertMessage = .na
    @Published var showAlert: Bool = false
    @Published var isSharing: Bool = false

    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager?.activityType = .fitness
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
            locationRegion = MKCoordinateRegion(center: locationManager.location?.coordinate ?? tiszapuspokiFaluCoords.center, span: tiszapuspokiFaluCoords.span)
            break
        @unknown default:
            alertType = .na
            showAlert = true
        }
    }

    func centerMap() {
        locationRegion = getUsersLocation()
    }

    func getUsersLocation() -> MKCoordinateRegion {
        MKCoordinateRegion(center: locationManager?.location?.coordinate ?? tiszapuspokiFaluCoords.center, span: tiszapuspokiFaluCoords.span)
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
        let locationData = ["lat" : last!.coordinate.latitude,
                            "long" : last!.coordinate.longitude] as [String: Any]
        Database.database().reference().child("portya_locs").child(String(sessionService!.userDetails!.groupNumber)).child(sessionService!.userDetails!.uid).setValue(locationData)
    }
}

extension CLLocationCoordinate2D {
    func equals(to loc: CLLocationCoordinate2D) -> Bool {
        let places = 5
        return self.latitude.rounded(toPlaces: places) == loc.latitude.rounded(toPlaces: places) &&
        self.longitude.rounded(toPlaces: places) == loc.longitude.rounded(toPlaces: places)
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
