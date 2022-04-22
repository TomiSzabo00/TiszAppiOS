//
//  ImagesView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import SwiftUI


struct ImagesView: View {
    
    @State var checkImages: Bool
    
    @ObservedObject var handler: ImagesHandlerImpl
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    private var gridItemLayout = [GridItem(.flexible(minimum: 10, maximum: 200), spacing: 20), GridItem(.flexible(minimum: 10, maximum: 200), spacing: 20)]
    
    init(checkImages: Bool) {
        self.checkImages = checkImages
        self.handler = ImagesHandlerImpl(mode: .loadImages, checkImages: checkImages)
    }
    
    var body: some View {
        ZStack {
            //Color.background.ignoresSafeArea()
            
            if handler.imageInfos.count > 0 {
                ScrollView {
                    
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach(handler.imageInfos) { imageInfo in
                            NavigationLink(destination: ImageDetailView(imageInfo: imageInfo, checkImages: self.checkImages).environmentObject(sessionService), label: {
                                ImageItemView(imageName: imageInfo.fileName, text: imageInfo.title)
                            })
                            
                        }
                    } //LazyVGrid end
                    .padding(10)
                } //ScrollView end
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
