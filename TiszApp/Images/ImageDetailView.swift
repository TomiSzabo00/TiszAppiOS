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
    
    @State var checkImages: Bool
    //@State var imageInfo: ImageItem? = nil
    
    @ObservedObject private var imageLoader : Loader
    @ObservedObject var handler: ImagesHandlerImpl
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State private var confirmationShown = false
    
    @State private var picScore: Double = 0
    
    @Environment(\.dismiss) var dismiss
    
    init(imageInfo: ImageItem, checkImages: Bool) {
        self._checkImages = State(initialValue: checkImages)
        self.handler = ImagesHandlerImpl(mode: .getDetails, checkImages: checkImages)
        self.imageLoader = Loader(imageInfo.fileName)
        handler.setChangeListener(for: imageInfo)
        handler.getImageAuthorDetails(imageInfo: handler.detail!)
        handler.getScorer(imageInfo: handler.detail!)
    }
    
    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }
    
    var body: some View {
        VStack{
            //Color.background.ignoresSafeArea()
            
            ScrollView{
                VStack(spacing: 20) {
                    HStack {
                        Text("Feltöltötte:\n\(handler.user?.userName ?? "Unknown") (\(handler.user?.groupNumber ?? -1). csapat)")
                            .padding(10)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                    
                    Image(uiImage: image ?? placeholder)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3)
//                        .shadow(color: Color.shadow, radius: 2, x: 3, y: 3)
//                        .shadow(color: Color.highlight, radius: 2, x: -2, y: -2)
                }
                .padding()
                
                
                if handler.detail!.score == -1 {
                    //add score to picture
                    if sessionService.userDetails!.admin && !checkImages && !handler.user!.admin {
                        //display element to add score
                        Text("Hány pontot adsz erre a képre?").padding(.top)
                        HStack {
                            Slider(value: $picScore, in: 0...10, step: 1)
                                .padding([.leading, .trailing])
                            Text(String(Int(picScore)))
                                .frame(width: 30)
                                .padding(.trailing)
                        }
                        .padding()
                        
                        Button("Pont feltöltése") {
                            handler.giveScoreForPic(imageInfo: handler.detail!, score: Int(picScore))
                        }
                        .padding()
                        
                    } else if !sessionService.userDetails!.admin {
                        Text("Ezt a képet még nem pontozta egyik szervező sem.")
                            .padding(.bottom)
                    }
                    
                } else {
                    Text("Erre a képre már adott \(handler.detail!.score) pontot \(handler.scorer?.userName ?? "...").")
                        .padding(.bottom)
                        .lineLimit(5)
                }
            }
            
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(handler.detail!.title)
        .navigationBarItems(trailing: sessionService.userDetails!.admin ? (checkImages ? HStack {
            Button(action: {
                handler.acceptImage(imageInfo: handler.detail!)
                dismiss()
            }) {
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
                
            }
            Button(
                role: .destructive,
                action: { confirmationShown = true }
            ) {
                Image(systemName: "trash")
                    .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
            }
        } :
                                                                            HStack {
            Button(action: {}) {
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(LinearGradient(Color(.systemBackground), Color(.systemBackground)))
                
            }
            Button(
                role: .destructive,
                action: { confirmationShown = true }
            ) {
                Image(systemName: "trash")
                    .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
            }
        }) : nil )
        .confirmationDialog(
            "Biztos ki akarod törölni a képet?",
            isPresented: $confirmationShown,
            titleVisibility: .visible
        ) {
            Button("Igen") {
                //delete pic
                Database.database().reference().child(checkImages ? "picsToDecide" : "pics").child(handler.detail!.fileName).removeValue()
                Storage.storage().reference().child("images/\(handler.detail!.fileName)").delete { error in
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
