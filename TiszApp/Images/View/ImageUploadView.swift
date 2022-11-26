//
//  ImageUploadView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import SwiftUI

struct ImageUploadView: View {
    @StateObject var vm = ImagesViewModel(mode: .na, checkImages: false)
    @State var showImagePicker = false
    @State var image: UIImage?
    
    @State var imageTitle: String = ""
    @State var succesfulUpload: Bool? = nil
    @State var uploaded: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                if let image = image {
                    SizedImage(image: image, width: 350, height: 500)
                        .padding()
                } else {
                    Text("Kérlek válassz egy képet.")
                        .frame(height: 250)
                }
                
                TextFieldWithIcon(textField: TextField("Cím (ha van)", text: $imageTitle), imageName: "pencil")
                    .padding()
                
                HStack(spacing: 30){
                    Button(action: {
                        self.showImagePicker = true
                    }, label: {
                        Text("Kép kiválasztása")
                    })
                    .buttonStyle(ElevatedButtonStyle())
                    
                    Button(action: {
                        //upload
                        if let image = image {
                            vm.uploadImage(title: imageTitle, image: image) { isSuccess in
                                self.succesfulUpload = isSuccess
                                uploaded = true
                            }
                        }
                    }, label: {
                        Text("Feltöltés")
                    })
                    .buttonStyle(ElevatedButtonStyle())
                }
                .padding()
                Spacer()
            }
            .sheet(isPresented: $showImagePicker, content: {
                imagePicker(image: $image, showPicker: $showImagePicker)
            })
            .alert(isPresented: $uploaded, content: {
                if succesfulUpload != nil {
                    if succesfulUpload == false {
                        return Alert(title: Text("Hiba"),
                                     message: Text("A kép feltöltése sikertelen. Próbáld meg később."))
                    } else {
                        return Alert(title: Text("Siker"),
                                     message: Text("A kép feltöltve jóváhagyásra. Amint egy szervező ellenőrizte, megtekintheted a Képek menüpont alatt"), dismissButton: .default(Text("Ok"), action: {
                            image = nil
                            imageTitle = ""
                        }))
                    }
                } else {
                    return Alert(title: Text(""), message: Text("Feltöltés folyamatban..."))
                }
            })
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ImageUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploadView()
    }
}
