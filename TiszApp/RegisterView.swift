//
//  RegisterView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 25..
//

import SwiftUI

struct RegisterView: View {
    @State var fullName = ""
    @State var id = ""
    
    @State var email = ""
    @State var password = ""
    @State var password2 = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView{
            
            
            VStack{
                Spacer()
                VStack{
                    TextField("Teljes neved", text: $fullName)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    TextField("Egyedi azonosító", text: $id)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .keyboardType(.numberPad)
                }
                .padding()
                
                Spacer()
                
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
                    SecureField("Jelszó megint", text: $password2)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            
                            guard !email.isEmpty, !password.isEmpty else{
                                return
                            }
                            
                            viewModel.signIn(email: email, password: password)
                            
                        }, label: { Text("Regisztráció").padding()})
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding(.top)
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Regisztráció")
            .padding()
        }
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
