//
//  TextItem.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 09..
//

import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseStorage


struct TextItem: Identifiable, Equatable {
    var id: String
    var title: String
    var text: String
    var author: String
    
    init(title: String, text: String, author: String, id: String) {
        self.title = title
        self.text = text
        self.author = author
        self.id = id
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let title = value["title"] as? String,
            let author = value["author"] as? String,
            let id = value["id"] as? String,
            let text = value["text"] as? String
        else {
            return nil
        }
        
        self.title = title
        self.id = id
        self.author = author
        self.text = text
    }
}


struct TextItemView: View {
    var text: String
    var title: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        VStack {
            Text(text)
                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80, alignment: .topLeading)
                .foregroundColor(Color(.label))
                .padding(20)
            Divider()
                .background(Color(.systemBackground))
            Text(title)
                .foregroundColor(Color(.label))
                .scaledToFit()
                .padding([.leading, .trailing, .bottom], 5)
        }
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color(.systemBackground))
            .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
    }
}

