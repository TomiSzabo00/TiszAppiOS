//
//  RegisterView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 25..
//

import SwiftUI
import FirebaseAuth

func customError(error: Error) -> String {
    var myError: String = "No match found for error type..."
    if let errCode = AuthErrorCode(rawValue: error._code) {
        switch errCode {
            case .emailAlreadyInUse:
                myError = "Ez a felhasználónév már foglalt."
            case .invalidEmail:
                myError = "Hibás formátum: A felhasználónév 1 szóból állhat csak, speciális karakterek nélkül."
            case .userNotFound:
                myError = "Ilyen felhasználónév nincs regisztrálva."
            case .networkError:
                myError = "Hálózat nem elérhető. Kapcsold be a mobilnetet, vagy próbáld meg később."
            case .weakPassword:
                myError = "A jelszó túl rövid. Legalább 6 karakter hosszúnak kell lennie."
            case .wrongPassword:
                myError = "Hibás jelszó."
            default:
                myError = "Ismeretlen a hiba oka."
            }
        }
    return myError
}

struct RegisterView: View {

    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var vm = RegistrationViewModelImpl(service: RegistrationServiceImpl())
    
    var body: some View {
        NavigationView{
            ScrollView{
            VStack{
                Spacer()
                VStack(spacing: 20){
                    TextField("Teljes neved", text: $vm.userDetails.fullName)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    TextField("Egyedi azonosító", text: $vm.userDetails.id)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .keyboardType(.numberPad)
                }
                .padding()
                
                
                VStack{
                    TextField("Felhasználónév", text: $vm.userDetails.userName)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    SecureField("Jelszó", text: $vm.userDetails.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    SecureField("Jelszó megint", text: $vm.userDetails.password2)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    
                    HStack{
                        Spacer()
                        Button(action: {
                        
                            //register
                            vm.register()
                            print(vm.userDetails.userName)
                            
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
            .alert(isPresented: $vm.hasError, content: {
                if case .failed(let error) = vm.state {
                    return Alert(title: Text("Hiba"),
                                 message: Text(customError(error:error)))
                } else {
                    return Alert(title: Text("Hiba"),
                    message: Text("Valami hiba történt. Próbáld újra."))
                }
                
            })
            .navigationBarTitle("Regisztráció", displayMode: .automatic)
            .toolbar{ToolbarItem(placement: .principal){
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {HStack{
                    Image(systemName: "arrow.down")}
                    Text("Vissza")
                }
                )}}
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
