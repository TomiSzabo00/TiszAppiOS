//
//  QuizInfoAlert.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 12..
//

import SwiftUI

struct QuizInfoAlert: View {
    @Binding var shown: Bool
    
    var body: some View {
        VStack {
            Text("Info").bold().padding()
            HStack {
                Text("Zöld gomb").foregroundColor(.green).bold().shadow(color: .black, radius: 3)
                Text(": tudsz jelezni").lineLimit(2)
            }
            .padding(10)
            HStack {
                Text("Sárga gomb").foregroundColor(.yellow).bold().shadow(color: .black, radius: 3)
                Text(": te, vagy a csapatodból valaki már jelzett, várj").lineLimit(10)
            }
            .padding(10)
            HStack {
                Text("Szürke gomb").foregroundColor(.gray).bold()
                Text(": nem lehet jelezni").lineLimit(2)
            }
            .padding(10)
            Divider()
            Button(action: {
                shown = false
            }, label: {
                Text("OK")
                    .padding(.bottom, 5)
                    .frame(width: UIScreen.main.bounds.width-50, height: 40)
            })
        }
        .frame(width: UIScreen.main.bounds.width-50)
        .background(Color.white.opacity(0.5))
        .cornerRadius(12)
        .clipped()
    }
}
