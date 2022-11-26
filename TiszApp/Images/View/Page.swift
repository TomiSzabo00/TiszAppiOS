import SwiftUI

struct Page: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @ObservedObject var handler: ImagesViewModel

    @State var checkImages: Bool

    var images: [ImageItem]

    @State var load: Bool = false

    private var gridItemLayout = [GridItem(.flexible(minimum: 10, maximum: 200), spacing: 20), GridItem(.flexible(minimum: 10, maximum: 200), spacing: 20)]

    init(handler: ImagesViewModel, checkImages: Bool, images: [ImageItem]) {
        self.handler = handler
        self.checkImages = checkImages
        self.images = images
    }

    var body: some View {
        //ScrollView {

        LazyVGrid(columns: gridItemLayout, spacing: 20) {
            ForEach(self.images) { imageInfo in
                NavigationLink(destination: ImageDetailView(imageInfo: imageInfo, checkImages: self.checkImages, teamNum: sessionService.teamNum).environmentObject(sessionService).fullBackground(), label: {
                    ImageItemView(imageName: imageInfo.fileName, text: imageInfo.title, load: self.load)
                })

            }
        } //LazyVGrid end
        .padding(10)
        //} //ScrollView end
        .onAppear {
            self.load = true
        }
    }
}
