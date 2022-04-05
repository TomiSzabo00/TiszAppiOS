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
            Color.background.ignoresSafeArea()
            //ScrollView{
                VStack{
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 180, height: 180)
                        .padding()
                        .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
                    
                    
                    VStack{
                        VStack{
                            SimpleTextFieldWithIcon(textField:
                                                        TextField("Felhasználónév", text: $vm.details.userName), imageName: "person.fill")
                            .padding(.bottom, 5)
                            SimpleSecureTextField(secureFied: SecureField("Jelszó", text: $vm.details.password), imageName: "lock.fill")
                        }
                        .padding()
                        
                        Button(action: {
                            //login
                            vm.login()
                        }, label: { Text("Bejelentkezés").bold()})
                        .buttonStyle(SimpleButtonStyle())
                        .padding(.bottom, 30)
                        
                        HStack{
                            Text("Nincs még fiókod?")
                            Button(action: {
                                showRegistration.toggle()
                            }, label: {Text("Regisztrálj!")
                                .bold()
                                .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
                            })
                            .sheet(isPresented: $showRegistration, content: { RegisterView()})
                            Spacer()
                        }
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
   // }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LoginView()
        }
    }
}
