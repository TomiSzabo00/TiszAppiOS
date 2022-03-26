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
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            ScrollView{
            VStack{
                Spacer()
                VStack(spacing: 20){
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
                            
                            //register
                            
                        }, label: { Text("Regisztrálok").padding()})
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
            .navigationBarTitle("Regisztráció", displayMode: .automatic)
            .toolbar{ToolbarItem(placement: .principal){
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {HStack{
                    Image(systemName: "arrow.down")}
                    Text("Vissza")
                }
                )}}
            .onTapGesture {
                endTextEditing()
            }
            .padding()
        }
    }
}
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
