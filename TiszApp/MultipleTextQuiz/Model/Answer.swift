import Foundation

struct Answer: Identifiable, Hashable {
    var id: UUID
    var answer: String

    init(id: UUID = UUID(), answer: String) {
        self.id = id
        self.answer = answer
    }
}
