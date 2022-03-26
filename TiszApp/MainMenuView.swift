//
//  MainMenuView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 25..
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        VStack{
            Spacer()
            Text("Bejelentkeztél.")
            Spacer()
            Button(action: {
                
            }, label: {
                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                Text("Kijelentkezés")
            })
            .padding()
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(15)
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainMenuView()
        }
    }
}
