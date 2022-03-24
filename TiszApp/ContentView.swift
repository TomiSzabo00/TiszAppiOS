//
//  ContentView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 23..
//

import SwiftUI

struct ContentView: View {
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView{
            
            VStack{
                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .padding()
                
                VStack{
                    TextField("Felhasználónév", text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    SecureField("Jelszó", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    Button(action: {
                        
                        //TODO: login
                        
                    }, label: { Text("Bejelentkezés")})
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding()
                    HStack{
                        Text("Nincs még fiókod?")
                        Button(action: {
                            
                            //TODO: register
                            
                        }, label: {Text("Regisztrálj!")})
                        Spacer()
                    }
                    .padding()
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Bejelentkezés")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
