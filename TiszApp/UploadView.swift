//
//  UploadView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 09..
//

import SwiftUI


struct UploadView: View {
    
    var body: some View {
        TabView {
            ImageUploadView()
                .tabItem {
                    Label("Kép", systemImage: "photo")
                }
            
            TextUploadView()
                .tabItem {
                    Label("Szöveg", systemImage: "doc.text")
                }
        }
        .navigationTitle("Feltöltés")
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
