//
//  MainMenuView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 25..
//

import SwiftUI
import FirebaseAuth

struct MainMenuView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    //private var gridItemLayout = Array(repeating: GridItem(.adaptive(minimum:100), spacing: 20), count: 2)
    
    private var gridItemLayout = [GridItem(.fixed(150), spacing: 20), GridItem(.fixed(150), spacing: 20)]

    var body: some View {
        VStack{
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(sessionService.buttonTitles.indices, id: \.self) {
                        Image(systemName: sessionService.buttonIcons[$0])
                            .font(.system(size: 30))
                            .frame(width: 150, height: 150, alignment: .center)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                }
                .padding(20)
            }
            Spacer()
            Button(action: {
                
                sessionService.logout()
                
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
            MainMenuView().environmentObject(SessionServiceImpl())
        }
    }
}
