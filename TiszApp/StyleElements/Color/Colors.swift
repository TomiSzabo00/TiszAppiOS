import SwiftUI

extension Color {
    static let background = Color("background")
    static let highlight = Color("highlight")
    static let shadow = Color("shadow")
    static let foreground = Color("foreground")
    static let gradientDark = Color("gradientDark")
    static let gradientLight = Color("gradientLight")
    static let gradientEnd = Color("gradientEnd")

    static let text = Color("btn_text")
    static let btn = Color("btn_day")
    static let main = Color("btn_s_day")
    static let secondary = Color("secondary")
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
