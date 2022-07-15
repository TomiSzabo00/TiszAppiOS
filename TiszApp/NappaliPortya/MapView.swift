//
//  MapView.swift
//  TiszApp
//
//  Created by Szabo Tamas on 2022. 07. 14..
//

import Combine
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @StateObject var vm: NappaliPortyaViewModel

    @State private var cancellables = Set<AnyCancellable>()

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if !mapView.showsUserLocation {
                parent.vm.locationRegion?.center = mapView.centerCoordinate
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let routePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = UIColor.systemOrange
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> some UIView {
        //vm.getPoints()
        let map = MKMapView(frame: .zero)
        map.delegate = context.coordinator
        map.showsUserLocation = true
        return map
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        let tiszapuspokiFaluCoords = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.213725, longitude: 20.318096), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))

        let region = MKCoordinateRegion(center: vm.locationRegion?.center ?? tiszapuspokiFaluCoords.center, span: tiszapuspokiFaluCoords.span)

//        vm.$lineCoordinates
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print("Failed to recive coordinates: \(error.localizedDescription)")
//                }
//            } receiveValue: { recievedCoordinates in
//                let polyline = MKPolyline(coordinates: recievedCoordinates, count: recievedCoordinates.count)
//                (uiView as! MKMapView).addOverlay(polyline)
//            }
//            .store(in: &cancellables)

        let polyline = MKPolyline(coordinates: vm.lineCoordinates, count: vm.lineCoordinates.count)
        (uiView as! MKMapView).addOverlay(polyline)

        (uiView as! MKMapView).setRegion(region, animated: true)
    }


}
