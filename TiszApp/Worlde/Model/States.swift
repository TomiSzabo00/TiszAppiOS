import Foundation

enum GameState {
    case inProgress
    case win
    case lose
}

enum LetterState {
    case na
    case no
    case inWord
    case match

    var name: String {
        switch self {
        case .na:
            return "na"
        case .no:
            return "no"
        case .inWord:
            return "inWord"
        case .match:
            return "match"
        }
    }
}
