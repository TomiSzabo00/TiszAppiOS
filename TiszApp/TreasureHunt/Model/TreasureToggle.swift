import Foundation

struct TreasureToggle: Identifiable, Hashable {
    let id = UUID()
    var state: Bool = false

    init(state: Bool = false) {
        self.state = state
    }
}
