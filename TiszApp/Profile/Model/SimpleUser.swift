import Foundation

struct SimpleUser: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var teammates: [SimpleUser]?
}
