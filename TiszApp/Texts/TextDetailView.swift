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
            //Color.background.ignoresSafeArea()
            
            ScrollView{
                VStack(spacing: 20) {
                    HStack {
                        Text("Feltöltötte:\n\(handler.user?.userName ?? "Unknown") (\(handler.user?.groupNumber ?? -1). csapat)")
                            .padding()
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                    
                    Text(textInfo.text)
                        .padding(20)
                        .lineLimit(1000)
                        .frame(maxWidth: UIScreen.main.bounds.width, alignment: .topLeading)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(textInfo.title)
        .navigationBarItems(trailing: sessionService.userDetails?.admin ?? false ? Button(
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

