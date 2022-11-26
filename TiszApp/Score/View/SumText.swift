import SwiftUI

struct SumText: View {
    var text: Text

    init(text: Text) {
        self.text = text
    }

    var body: some View {
        self.text
            .bold()
            .foregroundStyle(Color.text)
            .frame(width: 120)
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color.btn)
                .shadow(color: Color.main, radius: 0, x: 0, y: 3))
    }
}

struct SumText_Previews: PreviewProvider {
    static var previews: some View {
        SumText(text: Text("Sum:"))
    }
}
