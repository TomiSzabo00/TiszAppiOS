//
//  ImagesView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import SwiftUI


struct Page: View {
    @ObservedObject var handler: ImagesViewModelImpl
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State var checkImages: Bool
    
    var images: [ImageItem]
    
    @State var load: Bool = false
    
    private var gridItemLayout = [GridItem(.flexible(minimum: 10, maximum: 200), spacing: 20), GridItem(.flexible(minimum: 10, maximum: 200), spacing: 20)]
    
    init(handler: ImagesViewModelImpl, checkImages: Bool, images: [ImageItem]) {
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


struct ImagesView: View {
    
    @State var checkImages: Bool
    
    @ObservedObject var handler: ImagesViewModelImpl
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    init(checkImages: Bool) {
        self.checkImages = checkImages
        self.handler = ImagesViewModelImpl(mode: .loadImages, checkImages: checkImages)
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(.label).opacity(0.8))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color(.label).opacity(0.2))
    }
    
    var body: some View {
        ZStack {
            //Color.background.ignoresSafeArea()
            
            if handler.imageNames.count > 0 {
                TabView {
                    ForEach(1...(handler.imageNames.count-1)/6+1, id: \.self) {i in
                        Page(handler: self.handler, checkImages: self.checkImages, images: Array(handler.imageNames[(i-1)*6..<min(i*6, handler.imageNames.count)])).environmentObject(sessionService)
                    }
                }
                .tabViewStyle(.page)
            } else {
                Text("Nincs megjeleníthető kép.")
            }
            
        }
        .navigationTitle(checkImages ? "Képek ellenőrzése" : "Képek")
        .navigationBarTitleDisplayMode(.large)
    }
    
}

struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesView(checkImages: false).environmentObject(SessionServiceImpl())
    }
}
