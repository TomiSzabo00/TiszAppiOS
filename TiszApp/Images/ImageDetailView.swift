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
    @State var checkImages: Bool
    
    @ObservedObject private var imageLoader : Loader
    @ObservedObject var handler: ImagesHandlerImpl
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State private var confirmationShown = false
    
    @Environment(\.dismiss) var dismiss
    
    init(imageInfo: ImageItem, checkImages: Bool) {
        self.imageInfo = imageInfo
        self._checkImages = State(initialValue: checkImages)
        self.imageLoader = Loader(self.imageInfo.fileName)
        self.handler = ImagesHandlerImpl(mode: .getDetails, checkImages: checkImages)
        handler.getImageAuthorDetails(imageInfo: self.imageInfo)
    }
    
    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()
            
            ScrollView{
                VStack(spacing: 20) {
                    SimpleText(text: "Feltöltötte:\n\(handler.user?.userName ?? "Unknown") (\(handler.user?.groupNumber ?? -1). csapat)", padding: 10, maxLines: 2, maxWidth: .infinity, alignment: .leading)
                    
                    Image(uiImage: image ?? placeholder)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .shadow(color: Color.shadow, radius: 2, x: 3, y: 3)
                        .shadow(color: Color.highlight, radius: 2, x: -2, y: -2)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(imageInfo.title)
        .navigationBarItems(leading: checkImages ?
                            HStack {
            Spacer()
            Button(action: {
            handler.acceptImage(imageInfo: imageInfo)
            dismiss()
        }) {
            Image(systemName: "checkmark.circle")
            .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
            
        }} : nil, trailing: sessionService.userDetails!.admin ? (checkImages ? Button(
            role: .destructive,
            action: { confirmationShown = true }
        ) {
            Image(systemName: "trash")
                .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
        } :
            Button(
            role: .destructive,
            action: { confirmationShown = true }
        ) {
            Image(systemName: "trash")
                .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
        }) : nil )
        .confirmationDialog(
            "Biztos ki akarod törölni a képet?",
            isPresented: $confirmationShown,
            titleVisibility: .visible
        ) {
            Button("Igen") {
                //delete pic
                Database.database().reference().child(checkImages ? "picsToDecide" : "pics").child(self.imageInfo.fileName).removeValue()
                Storage.storage().reference().child("images/\(self.imageInfo.fileName)").delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        dismiss()
                        //handler.getImageInfos()
                    }
                }
            }
        }
    }
}
