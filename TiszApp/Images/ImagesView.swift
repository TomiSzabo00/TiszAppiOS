//
//  ImagesView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import SwiftUI


struct Page: View {
    @ObservedObject var handler: ImagesHandlerImpl
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State var checkImages: Bool
    
    var firstItemIndex: Int
    var lastItemIndex: Int
    
    private var gridItemLayout = [GridItem(.flexible(minimum: 10, maximum: 200), spacing: 20), GridItem(.flexible(minimum: 10, maximum: 200), spacing: 20)]
    
    init(handler: ImagesHandlerImpl, checkImages: Bool, firstItemName: Int, lastItemName: Int) {
        self.handler = handler
        self.checkImages = checkImages
        self.firstItemIndex = firstItemName
        self.lastItemIndex = lastItemName
    }
    
    var body: some View {
        //ScrollView {
            
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach(handler.imageInfos) { imageInfo in
                    NavigationLink(destination: ImageDetailView(imageInfo: imageInfo, checkImages: self.checkImages, teamNum: sessionService.teamNum).environmentObject(sessionService), label: {
                        ImageItemView(imageName: imageInfo.fileName, text: imageInfo.title)
                    })
                    
                }
            } //LazyVGrid end
            .padding(10)
        //} //ScrollView end
        .onAppear {
            self.handler.loadNextPage(from: firstItemIndex, to: lastItemIndex)
        }
    }
}


struct ImagesView: View {
    
    @State var checkImages: Bool
    
    @ObservedObject var handler: ImagesHandlerImpl
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    init(checkImages: Bool) {
        self.checkImages = checkImages
        self.handler = ImagesHandlerImpl(mode: .loadImages, checkImages: checkImages)
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(.label).opacity(0.8))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color(.label).opacity(0.2))
    }
    
    var body: some View {
        ZStack {
            //Color.background.ignoresSafeArea()
            
            if handler.imageNames.count > 0 {
                TabView {
                    ForEach(1...(handler.imageNames.count-1)/6+1, id: \.self) {i in
                        Page(handler: self.handler, checkImages: self.checkImages, firstItemName: (i-1)*6, lastItemName: min(i*6, handler.imageNames.count)).environmentObject(sessionService)
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
