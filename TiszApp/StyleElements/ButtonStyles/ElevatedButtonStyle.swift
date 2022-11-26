import SwiftUI

struct ElevatedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(15)
            .foregroundColor(
                isEnabled ? Color.text : Color.white)
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .background(
                isEnabled ? Color.btn : .gray)
            .cornerRadius(10)
            .offset(y: configuration.isPressed ? 6 : 0)
            .shadow(color: isEnabled ? Color.main : .shadow, radius: 0, x: 0, y: configuration.isPressed ? 0 : 6)
    }
}
