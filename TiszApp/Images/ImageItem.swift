//
//  ImageItem.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseStorage

let placeholder = UIImage(systemName: "clock.arrow.circlepath")!

struct ImageItem: Identifiable, Equatable {
    var id: UUID = UUID()
    
    var title: String
    var fileName: String
    var author: String
    var image: UIImage?
    
    init(title: String, fileName: String, author: String, image: UIImage? = nil) {
        self.title = title
        self.fileName = fileName
        self.author = author
        self.image = image
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let title = value["title"] as? String,
            let author = value["author"] as? String,
            let fileName = value["fileName"] as? String
        else {
            return nil
        }
        
        self.title = title
        self.fileName = fileName
        self.author = author
        self.image = nil
    }
}

///source:  https://benmcmahen.com/firebase-image-in-swiftui/

final class Loader : ObservableObject {

    @Published var data: Data? = nil

    init(_ id: String){
        // the path to the image
        let url = "images/\(id)"
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("\(error.localizedDescription)")
            }

            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}

struct ImageItemView: View {
    
    var text: String
    @ObservedObject private var imageLoader : Loader
    
    init(imageName: String, text: String) {
        self.imageLoader = Loader(imageName)
        self.text = text
    }
    
    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }
    
    var body: some View {
        VStack {
            Image(uiImage: image ?? placeholder)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 100)
                .mask(Rectangle()
                    .frame(maxHeight: 190, alignment: .top))
            Text(text)
                .foregroundColor(Color.foreground)
                .scaledToFit()
                .padding([.leading, .trailing, .bottom], 5)
        }
        .background(Color.background)
        .cornerRadius(20)
        //.frame(alignment: .center)
        .shadow(color: Color.shadow, radius: 3, x: 3, y: 3)
        .shadow(color: Color.highlight, radius: 3, x: -2, y: -2)
    }
    
}
