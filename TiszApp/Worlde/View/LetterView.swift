import SwiftUI

struct LetterView: View {
    @State var l : Letter
    var bg: Color
    var degrees: Double

    var body: some View {
        ZStack {
            Rectangle()
                .strokeBorder(Color.accentColor, lineWidth: 1)
                .background(Rectangle().fill(bg))
                .frame(width: 50, height: 50)
                .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))

            Text(l.letter.uppercased())
                .foregroundColor(.accentColor)
                .frame(width: 50, height: 50)
        }
    }
}

struct LetterView_Previews: PreviewProvider {
    static var previews: some View {
        LetterView(l: Letter("A"), bg: .green, degrees: 0.0)
    }
}
