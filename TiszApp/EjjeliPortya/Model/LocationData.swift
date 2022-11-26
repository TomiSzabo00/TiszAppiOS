import Foundation
import FirebaseDatabase

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
