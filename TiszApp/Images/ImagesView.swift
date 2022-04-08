//
//  ImagesView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import SwiftUI


struct ImagesView: View {
    
    @ObservedObject var handler: ImagesHandlerImpl = ImagesHandlerImpl()
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    private var gridItemLayout = [GridItem(.flexible(minimum: 10, maximum: 200), spacing: 20), GridItem(.flexible(minimum: 10, maximum: 200), spacing: 20)]
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(handler.imageInfos) { imageInfo in
                        NavigationLink(destination: ImageDetailView(imageInfo: imageInfo).environmentObject(sessionService), label: {
                            ImageItemView(imageName: imageInfo.fileName, text: imageInfo.title)
                        })
                        
                    }
                } //LazyVGrid end
                .padding(10)
            } //ScrollView end
        }
        .navigationTitle("Képek megtekintése")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesView().environmentObject(SessionServiceImpl())
    }
}
