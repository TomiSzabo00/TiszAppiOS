//
//  ImageUploadView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import SwiftUI

struct ImageUploadView: View {
    
    @State var showImagePicker = false
    @State var image: UIImage?
    
    @State var imageTitle: String = ""
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                
                if image != nil {
                    SimpleImage(image: image!, width: 350, height: 500)
                } else {
                    ZStack {
                        SimpleRectangle(width: 350, height: 500)
                        Text("Kérlek válassz egy képet.")
                            .foregroundColor(Color.foreground)
                    }
                }
                
                SimpleTextFieldWithIcon(textField: TextField("Cím (ha van)", text: $imageTitle), imageName: "pencil")
                    .padding()
                
                HStack(spacing: 30){
                    Button(action: {
                        self.showImagePicker = true
                    }, label: {
                        Text("Kép kiválasztása")
                    })
                    .buttonStyle(SimpleButtonStyle())
                    
                    Button(action: {
                        //upload
                    }, label: {
                        Text("Feltöltés")
                    })
                    .buttonStyle(SimpleButtonStyle())
                }
                .padding()
                Spacer()
            }
            .sheet(isPresented: $showImagePicker, content: {
                imagePicker(image: $image, showPicker: $showImagePicker)
            })
        }
    }
}

struct ImageUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploadView()
    }
}
