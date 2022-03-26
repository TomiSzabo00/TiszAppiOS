//
//  LoginView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 25..
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    
    @State private var showRegistration = false
    
    var body: some View {
        VStack{
            Spacer()
            Image("icon")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .padding()
            
            VStack{
                VStack{
                    TextField("Felhasználónév", text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    SecureField("Jelszó", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                .padding()
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else{
                        return
                    }
                    
                    //login
                    
                }, label: { Text("Bejelentkezés")})
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding(.bottom)
                HStack{
                    Text("Nincs még fiókod?")
                    Button(action: {
                       
                        showRegistration.toggle()
                        
                    }, label: {Text("Regisztrálj!")})
                    .sheet(isPresented: $showRegistration, content: { RegisterView()})
                    Spacer()
                }
            }
            Spacer()
            Spacer()
        }
        .onTapGesture {
            endTextEditing()
        }
        .padding(.leading)
        .padding(.trailing)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
