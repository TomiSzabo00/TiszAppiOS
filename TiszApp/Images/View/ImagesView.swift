//
//  ImagesView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import SwiftUI

struct ImagesView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @ObservedObject var handler: ImagesViewModel
    @State var checkImages: Bool

    init(checkImages: Bool) {
        self.checkImages = checkImages
        self.handler = ImagesViewModel(mode: .loadImages, checkImages: checkImages)
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(.label).opacity(0.8))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color(.label).opacity(0.2))
    }
    
    var body: some View {
        ZStack {
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
