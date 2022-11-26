import SwiftUI

struct TextItemView: View {
    var text: String
    var title: String

    init(title: String, text: String) {
        self.title = title
        self.text = text
    }

    var body: some View {
        VStack {
            Text(text)
                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80, alignment: .topLeading)
                .foregroundColor(Color.text)
                .padding(20)
            Divider()
                .background(Color.text)
            Text(title)
                .foregroundColor(Color.text)
                .scaledToFit()
                .padding([.leading, .trailing, .bottom], 5)
        }
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.btn)
            .shadow(color: Color.main, radius: 0, x: 0, y: 3))
    }
}


struct TextItemView_Previews: PreviewProvider {
    static var previews: some View {
        TextItemView(title: "Title", text: "Text")
    }
}
