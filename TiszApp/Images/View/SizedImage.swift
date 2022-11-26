import SwiftUI

struct SizedImage: View {
    var image: UIImage
    var width: CGFloat
    var height: CGFloat

    init(image: UIImage, width: CGFloat, height: CGFloat) {
        self.image = image
        self.width = width
        self.height = height
    }

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .frame(maxWidth: self.width, maxHeight: self.height, alignment: .center)
    }
}
