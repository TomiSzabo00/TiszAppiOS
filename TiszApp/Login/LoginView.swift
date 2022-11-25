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
        ZStack {
            VStack {
                Spacer()

                Image("logo")
                    .resizable()
                    .frame(width: 180, height: 180)
                    .padding()


                VStack{
                    VStack{
                        SimpleTextFieldWithIcon(textField:
                                                    TextField("Felhasználónév", text: $vm.details.userName), imageName: "person.fill")
                        .padding(.bottom, 5)
                        .autocapitalization(.none)
                        SimpleSecureTextField(secureFied: SecureField("Jelszó", text: $vm.details.password), imageName: "lock.fill")
                    }
                    .padding()

                    HStack {
                        Spacer()
                        Button(action: {
                            //login
                            vm.login()
                        }, label: { Text("Bejelentkezés")})
                        .buttonStyle(SimpleButtonStyle())
                        .padding(.bottom, 30)
                    }
                    .padding(.trailing)




                    HStack{
                        Text("Nincs még fiókod?")
                        Button(action: {
                            showRegistration.toggle()
                        }, label: {Text("Regisztrálj!")
                                .bold()
                                .foregroundStyle(Color.secondary)
                        })
                        .sheet(isPresented: $showRegistration, content: { RegisterView()})
                        Spacer()
                    }
                    .padding(.leading)
                }
                Spacer()
            }
            .alert(isPresented: $vm.hasError, content: {
                if case .failed(let error) = vm.state {
                    return Alert(title: Text("Hiba"),
                                 message: Text(customError(error:error)))
                } else {
                    return Alert(title: Text("Hiba"),
                                 message: Text("Valami hiba történt. Próbáld újra."))
                }

            })

            .padding(.leading)
            .padding(.trailing)
        }
        .navigationBarHidden(true)
        .onTapGesture {
            endTextEditing()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LoginView()
        }
    }
}
