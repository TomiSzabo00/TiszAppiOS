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
    
    var body: some View {
        VStack{
            Spacer()
            VStack {
                Text("Szia, \(sessionService.userDetails?.fullName ?? "N/A")")
                    .bold()
                    .padding()
                Text("Csapatod: \(sessionService.userDetails?.groupNumber ?? -1)")
                Text("Admin vagy? \(sessionService.userDetails?.admin ?? false ? "Igen" : "Nem")")
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
