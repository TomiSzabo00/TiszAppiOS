import Foundation
import FirebaseDatabase

struct ColorList: Decodable {
    var colors: [String]

    init(colors: [String]) {
        self.colors = colors
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String]
        else {
            return nil
        }
        self.colors = value
    }
}
