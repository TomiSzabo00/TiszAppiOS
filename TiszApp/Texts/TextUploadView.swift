//
//  TextUploadView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 09..
//

import SwiftUI
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

struct TextUploadView: View {
    
    @State var text: String = ""
    @State var textTitle: String = ""
    
    @State var succesfulUpload: Bool? = nil
    @State var uploaded: Bool = false
    
    init() {
            UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ScrollView {
            //Color.background.ignoresSafeArea()
            VStack {
                
                SimpleTextFieldWithIcon(textField: TextField("Cím", text: $textTitle), imageName: "pencil")
                    .padding()
                VStack {
                    Text("Tartalom:")
                        .padding(.leading)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    TextEditor(text: $text)
                        .background(Color.secondary)
                        .cornerRadius(10)
                        .frame(minHeight: 300)
                        .padding([.leading, .trailing])
                    
                }
                
                HStack(){
                    Spacer()
                    
                    Button(action: {
                        //upload
                        if text != "" && textTitle != "" {
                            uploadText(title: textTitle, text: text)
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
            .alert(isPresented: $uploaded, content: {
                if succesfulUpload != nil {
                if succesfulUpload == false {
                    return Alert(title: Text("Hiba"),
                                 message: Text("A szöveg feltöltése sikertelen. Próbáld meg később."))
                } else {
                    return Alert(title: Text("Siker"),
                                 message: Text("A szöveg feltöltve, megtekintheted a Szövegek menüpont alatt"), dismissButton: .default(Text("Ok"), action: {
                        text = ""
                        textTitle = ""
                    }))
                }
                } else {
                    return Alert(title: Text(""), message: Text("Feltöltés folyamatban..."))
                }
            })
        }
        .navigationBarTitleDisplayMode(.large)
        .onTapGesture {
            endTextEditing()
        }
    }
    
    func uploadText(title: String, text: String) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
        let id = dateFormatter.string(from: date)
        
        let textInfo = ["author" : Auth.auth().currentUser?.uid ?? "unknown",
                        "id" : id,
                        "title" : title,
                        "text" : text] as [String: Any]
        
        Database.database().reference().child("texts").child(id).setValue(textInfo) { (err, _) in
            if let err = err {
                print(err.localizedDescription)
                succesfulUpload = false
            }
            succesfulUpload = true
            
        }
        
        
    }
}

struct TextUploadView_Previews: PreviewProvider {
    static var previews: some View {
        TextUploadView()
    }
}
