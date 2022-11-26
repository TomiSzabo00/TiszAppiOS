import SwiftUI
import MapKit

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
