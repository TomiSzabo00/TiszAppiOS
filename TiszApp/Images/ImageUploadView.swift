//
//  ImageUploadView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import SwiftUI
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

struct ImageUploadView: View {
    
    @State var showImagePicker = false
    @State var image: UIImage?
    
    @State var imageTitle: String = ""
    @State var succesfulUpload: Bool? = nil
    @State var uploaded: Bool = false
    
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
                        if image != nil {
                            uploadImage(image: image!)
                            uploaded = true
                        }
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
        .navigationTitle("Kép feltöltése")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func uploadImage(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1) {
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
            let fileName = dateFormatter.string(from: date)
            
            let imageRef = Storage.storage().reference().child("images/\(fileName)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageRef.putData(imageData, metadata: metadata) { (_, err) in
                if let err = err {
                    print("error: \(err.localizedDescription)")
                    succesfulUpload = false
                } else {
                    succesfulUpload = true
                    print("image uploaded")
                    //upload to realtime db
                    let imageInfo = ["author" : Auth.auth().currentUser?.uid ?? "unknown",
                                 "fileName" : fileName,
                                 "title" : imageTitle.isEmpty ? fileName : imageTitle] as [String: Any]
                    
                    Database.database().reference().child("picsToDecide").child(fileName).setValue(imageInfo)
                }
            }
        }
    }
    
}

struct ImageUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploadView()
    }
}
