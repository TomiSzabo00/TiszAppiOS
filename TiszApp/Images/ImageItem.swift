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

let placeholder: UIImage = UIImage(systemName: "arrow.2.circlepath")!

struct ImageItem: Identifiable, Equatable {
    var id: UUID = UUID()
    
    var title: String
    var fileName: String
    var author: String
    var score: Int
    var scorerUID: String
    
    init(title: String, fileName: String, author: String, score: Int, scorerUID: String) {
        self.title = title
        self.fileName = fileName
        self.author = author
        self.score = score
        self.scorerUID = scorerUID
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let title = value["title"] as? String,
            let author = value["author"] as? String,
            let fileName = value["fileName"] as? String,
            let score = value["score"] as? Int,
            let scorerUID = value["scorerUID"] as? String
        else {
            return nil
        }
        
        self.title = title
        self.fileName = fileName
        self.author = author
        self.score = score
        self.scorerUID = scorerUID
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
        ref.getData(maxSize: 2 * 1024 * 1024) { data, error in
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
    
    private var rotationAnimation: Animation {
        .easeInOut(duration: 1)
        .repeatForever(autoreverses: false)
    }
    
    @State private var isSyncing: Bool = false
    
    var body: some View {
        VStack {
            if image == nil {
                Image(systemName: "arrow.2.circlepath")
                    .symbolVariant(.circle.fill)
                    .font(.largeTitle)
                    .rotationEffect(.init(degrees: isSyncing ? 360 : 0))
                    .animation(isSyncing ? rotationAnimation : .default, value: isSyncing)
                    .padding(70)
                    .frame(maxWidth: UIScreen.main.bounds.width/2-20, maxHeight: 100)
                    .mask(Rectangle()
                        .frame(maxHeight: 190, alignment: .top))
            } else {
                Image(uiImage: image!)
                                .resizable()
                                .scaledToFill()
                                .frame(maxHeight: 100)
                                .mask(Rectangle()
                                    .frame(maxHeight: 190, alignment: .top))
            }
            
            Text(text)
                .foregroundColor(Color(.label))
                .scaledToFit()
                .padding([.leading, .trailing, .bottom], 5)
        }
        //.background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color(.systemBackground))
            .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
        //.frame(alignment: .center)
//        .shadow(color: Color.shadow, radius: 3, x: 3, y: 3)
//        .shadow(color: Color.highlight, radius: 3, x: -2, y: -2)
        .onAppear {
            isSyncing = true
        }
    }
    
}