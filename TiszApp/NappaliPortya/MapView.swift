//
//  MapView.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 14..
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    @StateObject var vm: NappaliPortyaViewModel

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if !mapView.showsUserLocation {
                parent.vm.locationRegion?.center = mapView.centerCoordinate
                print("changed")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> some UIView {
        let map = MKMapView(frame: .zero)
        map.delegate = context.coordinator
        map.showsUserLocation = true
        return map
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        let tiszapuspokiFaluCoords = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.213725, longitude: 20.318096), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))

        let region = MKCoordinateRegion(center: vm.locationRegion?.center ?? tiszapuspokiFaluCoords.center, span: tiszapuspokiFaluCoords.span)

        (uiView as! MKMapView).setRegion(region, animated: true)
    }
}
