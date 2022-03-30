//
//  RegisterView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 25..
//

import SwiftUI
import FirebaseAuth

func customAlert(errTpye: AuthErrorType) -> Alert {
    return Alert(title: Text("Hiba"),
                 message: {
        switch errTpye {
        case .noMatchingPasswords:
            return Text("A két jelszó nem egyezik.")
        case .noFullNameInDatabase:
            return Text("Nincs ilyen nevű táborozó az adatbázisban.")
        case .noMatchingNameAndID:
            return Text("Ehhez a névhez nem ez az azonosító tartozik. Azonosítás sikertelen.")
        default:
            return Text("Ismeretlen hiba történt. Próbáld újra.")
        }
    }())
}

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
    
    @State var loading: Bool = false
    
    @State var predictableValues: Array<String> = []
    @State var predictedValue: Array<String> = []
    @State var prefix: String = "Teljes neved"
    
    init() {
        loading = vm.service.isloading
    }
    
    var body: some View {
        switch loading {
        case true:
            ProgressView{
                
            }
        default:
            NavigationView{
                ScrollView{
                VStack{
                    Spacer()
                    VStack(spacing: 20){
                        PredictingTextField(predictableValues: $vm.service.allUserNames, predictedValues: self.$predictedValue, textFieldInput: $vm.userDetails.fullName, textFieldTitle: prefix)
                        ZStack {
                            TextField("Egyedi azonosító", text: $vm.userDetails.id)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .disableAutocorrection(true)
                                .keyboardType(.numberPad)
                            
                            if self.predictedValue.count > 0 {
                                ScrollView {
                                    ForEach(self.predictedValue, id: \.self) { value in
                                        VStack {
                                            Button(action: {
                                                endTextEditing()
                                                vm.userDetails.fullName = value
                                            }, label: {
                                                Text(value)
                                            })
                                            .foregroundColor(Color.primary)
                                            .padding(10)
                                            .frame(maxWidth: .infinity)
                                            
                                            Rectangle().fill(Color.primary).frame(width: 250, height: 1, alignment: .center)
                                        }
                                    }
                                        
                                }
                                .background(.ultraThinMaterial)
                                .cornerRadius(20)
                                .frame(height: 200, alignment: .center)
                            }
                            
                        } //ZStack
                        
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
                    if vm.errorType != .na{
                        return customAlert(errTpye: vm.errorType)
                    } else if case .failed(let error) = vm.state {
                        return Alert(title: Text("Hiba"),
                                     message: Text(customError(error:error)))
                    } else {
                        return Alert(title: Text("Hiba"),
                        message: Text("Valami hiba történt. Próbáld újra."))
                    }
                })
                .onTapGesture {
                    endTextEditing()
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
                .padding()
            }
        }
        }
        
  }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
