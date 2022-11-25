import Foundation
import FirebaseDatabase

struct Token: Decodable {
    var token: String

    init(token: String) {
        self.token = token
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: String],
            let token = value["token"]
        else {
            return nil
        }

        self.token = token
    }
}
