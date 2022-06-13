//
//  SpecificSongView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 13..
//

import SwiftUI

struct SpecificSongView: View {
    
    var title: String
    var lyrics: String
    
    var body: some View {
        ScrollView {
            VStack {
                Text(title)
                    .bold()
                    .padding()
                    .font(.system(size: 20))
                    .lineLimit(3)
                HStack {
                    Text(lyrics)
                        .padding()
                    Spacer()
                }
            }
        }
    }
}

struct SpecificSongView_Previews: PreviewProvider {
    static var previews: some View {
        SpecificSongView(title: "Proba", lyrics: "Proba\nproba")
    }
}
