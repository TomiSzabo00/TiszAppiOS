import Foundation

struct Letter: Identifiable, Hashable {
    let id = UUID()
    var letter: String
    var state: LetterState = .na

    init(_ letter : String = "") {
        self.letter = letter
    }
}
