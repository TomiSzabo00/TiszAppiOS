import SwiftUI

struct ImageItemView: View {
    var text: String
    @ObservedObject private var imageLoader : Loader

    init(imageName: String, text: String, load: Bool = false) {
        if(load) {
            self.imageLoader = Loader(imageName)
        } else {
            self.imageLoader = Loader(nil)
        }
        self.text = text
    }

    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }

    private var rotationAnimation: Animation {
        .easeInOut(duration: 1)
        .repeatForever(autoreverses: false)
    }

    @State private var isSyncing: Bool = false

    var body: some View {
        VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100, alignment: .top)
                } else {
                    Image(systemName: "arrow.2.circlepath")
                        .symbolVariant(.circle.fill)
                        .foregroundColor(Color.text)
                        .font(.largeTitle)
                        .rotationEffect(.init(degrees: isSyncing ? 360 : 0))
                        .animation(isSyncing ? rotationAnimation : .default, value: isSyncing)
                        .padding(70)
                        .frame(maxWidth: UIScreen.main.bounds.width/2-20, maxHeight: 100)
                        .mask(Rectangle()
                            .frame(height: 190, alignment: .top))
                }

            Text(text)
                .foregroundColor(Color.text)
                .padding(5)
                .frame(maxWidth: .infinity)
                .background(Color.btn)
        }
        .cornerRadius(10)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.btn)
            .shadow(color: Color.main, radius: 0, x: 0, y: 3))
        .onAppear {
            isSyncing = true
        }
    }

}
