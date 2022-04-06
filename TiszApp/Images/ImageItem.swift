//
//  ImageItem.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import SwiftUI
import FirebaseDatabase

struct ImageItem: Identifiable {
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

struct ImageItemView: View {
    
    @State var image: UIImage?
    @State var fileName: String
    
    var body: some View {
        VStack {
            if image == nil {
                Image(systemName: "clock.arrow.circlepath")
                    .resizable()
                    .scaledToFit()
                    .padding(60)
                    .foregroundColor(Color.foreground)
            } else {
            Image(uiImage: image!)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 100)
                .mask(Rectangle()
                    .frame(maxHeight: 190, alignment: .top))
            }
            Text(fileName)
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
