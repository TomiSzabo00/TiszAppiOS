import SwiftUI

enum BackroundStyle {
    case normal
    case gray
    case color
}

struct SignalBGRectangle: View {
    var width: CGFloat
    var height: CGFloat
    var bg: BackroundStyle

    init(width: CGFloat, height: CGFloat, bg: BackroundStyle = .normal) {
        self.width = width
        self.height = height
        self.bg = bg
    }

    var body: some View {
        switch self.bg {
        case .normal:
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.secondary)
                .frame(width: self.width, height: self.height, alignment: .center)
                .shadow(color: Color.shadow.opacity(0.2), radius: 4, x: 1, y: 3)
        case .gray:
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray)
                .frame(width: self.width, height: self.height, alignment: .center)
        case .color:
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.btn)
                .frame(width: self.width, height: self.height, alignment: .center)
                .shadow(color: Color.main, radius: 0, x: 0, y: 6)
        }
    }
}
