//
//  LoginView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 25..
//

import SwiftUI
import FirebaseDatabase


struct LoginView: View {
    @StateObject private var vm = LoginViewModelImpl(service: LoginServiceImpl())
    
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
                    TextField("Felhasználónév", text: $vm.details.userName)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    SecureField("Jelszó", text: $vm.details.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                .padding()
                
                Button(action: {
                    
                    //login
                    vm.login()
                    
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
        .alert(isPresented: $vm.hasError, content: {
            if case .failed(let error) = vm.state {
                return Alert(title: Text("Hiba"),
                             message: Text(error.localizedDescription))
            } else {
                return Alert(title: Text("Hiba"),
                message: Text("Valami hiba történt. Próbáld újra."))
            }
            
        })
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
