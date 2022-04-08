//
//  TextDetailView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 09..
//

import SwiftUI
import FirebaseDatabase
import FirebaseStorage

struct TextDetailView: View {
    
    var textInfo: TextItem
    @ObservedObject var handler: TextsHandlerImpl = TextsHandlerImpl(mode: .getDetails)
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State private var confirmationShown = false
    
    @Environment(\.dismiss) var dismiss
    
    init(textInfo: TextItem) {
        self.textInfo = textInfo
        handler.getTextAuthorDetails(textInfo: self.textInfo)
    }
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()
            
            ScrollView{
                VStack(spacing: 20) {
                    SimpleText(text: "Feltöltötte:\n\(handler.user?.userName ?? "Unknown") (\(handler.user?.groupNumber ?? -1). csapat)", padding: 10, maxLines: 2, maxWidth: .infinity, alignment: .leading)
                    
                    SimpleText(text: textInfo.text, padding: 20, maxLines: 1000, maxWidth: .infinity, alignment: .topLeading)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(textInfo.title)
        .navigationBarItems(trailing: sessionService.userDetails!.admin ? Button(
            role: .destructive,
            action: { confirmationShown = true }
        ) {
            Image(systemName: "trash")
                .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
        } : nil )
        .confirmationDialog(
            "Biztos ki akarod törölni a szöveget?",
            isPresented: $confirmationShown,
            titleVisibility: .visible
        ) {
            Button("Igen") {
                //delete pic
                Database.database().reference().child("texts").child(self.textInfo.id).removeValue()
                dismiss()
            }
        }
    }
}

