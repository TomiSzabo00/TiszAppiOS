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
//                            image = nil
//                            imageTitle = ""
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
        }
    }
    
    func uploadImage(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1) {
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
            let fileName = dateFormatter.string(from: date)
            
            let imageRef = Storage.storage().reference().child("images/\(fileName)")
            
            imageRef.putData(imageData, metadata: nil) { (_, err) in
                if let err = err {
                    print("error: \(err.localizedDescription)")
                } else {
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
