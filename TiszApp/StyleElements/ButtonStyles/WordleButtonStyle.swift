import SwiftUI

struct WordleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .cornerRadius(3)
            .offset(y: configuration.isPressed ? 1 : 0)
            .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: configuration.isPressed ? 0 : 1)
    }
}
