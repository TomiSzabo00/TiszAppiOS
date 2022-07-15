//
//  NappaliPortyaViewModel.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 14..
//

import Combine
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

    private var service: NappaliPortyaService?

    private var cancellables = Set<AnyCancellable>()
    @Published var lineCoordinates = [CLLocationCoordinate2D]()
    @Published var currTeam = 0

    override init() {
        super.init()
        self.service = NappaliPortyaService(service: sessionService)
        asd()
    }

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
        manager.distanceFilter = 3
        let last = locations.last

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
        let id = dateFormatter.string(from: date)
        
        let locationData = ["lat" : last!.coordinate.latitude,
                            "long" : last!.coordinate.longitude] as [String: Any]
        Database.database().reference().child("nappali_porty_locs")
            .child(String(sessionService!.userDetails!.groupNumber))
            .child(sessionService!.userDetails!.uid)
            .child(id)
            .setValue(locationData)
    }

    func asd() {
        service!.$allCoordinates
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Failed all coords: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] updatedArray in
                guard let self = self else { return }
                if updatedArray.indices.contains(self.sessionService?.userDetails?.groupNumber ?? 0) {
                    self.lineCoordinates = updatedArray[self.sessionService?.userDetails?.groupNumber ?? 0]
                }
            }
            .store(in: &cancellables)

//        service.$currTeam
//            .sink { newTeam in
//                self.lineCoordinates = self.allCoordinates[newTeam]
//                print("new coords")
//            }
//            .store(in: &cancellables)
    }

    func up() {
        currTeam += 1
        print(currTeam)
        lineCoordinates = service!.allCoordinates[currTeam]
        print(lineCoordinates)
    }

    func down() {
        currTeam -= 1
        print(currTeam)
        lineCoordinates = service!.allCoordinates[currTeam]
        print(lineCoordinates)
    }
}
