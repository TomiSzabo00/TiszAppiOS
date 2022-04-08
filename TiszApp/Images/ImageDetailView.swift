//
//  ImageDetailView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 08..
//

import SwiftUI
import FirebaseDatabase
import FirebaseStorage

struct ImageDetailView: View {
    
    var imageInfo: ImageItem
    @ObservedObject private var imageLoader : Loader
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State private var confirmationShown = false
    
    @State private var user: User = User.new
    
    init(imageInfo: ImageItem) {
        self.imageInfo = imageInfo
        self.imageLoader = Loader(self.imageInfo.fileName)
    }
    
    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()
            
            ScrollView{
                VStack(spacing: 20) {
                    SimpleText(text: "Feltöltötte:\n\(user.userName) (\(user.groupNumber). csapat)", maxLines: 2, maxWidth: .infinity)
                    
                    Image(uiImage: image ?? placeholder)
                        .resizable()
                        .scaledToFit()
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(imageInfo.title)
        .navigationBarItems(trailing: sessionService.userDetails!.admin ? Button(
            role: .destructive,
            action: { confirmationShown = true }
        ) {
            Image(systemName: "trash")
                .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
        } : nil )
        .confirmationDialog(
            "Biztos ki akarod törölni a képet?",
            isPresented: $confirmationShown,
            titleVisibility: .visible
        ) {
            Button("Igen") {
                //delete pic
            }
        }
    }
}
