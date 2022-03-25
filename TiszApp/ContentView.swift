//
//  ContentView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 23..
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {

    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            // Success
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        })
    }
    
    func register(email: String, password: String){
        auth.createUser(withEmail: email, password: password, completion: { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            //Success
            DispatchQueue.main.async {
                self?.signedIn = true
            }
            
        })
    }
    
}

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.isSignedIn {
                VStack{
                    Text("Bejelentkeztél.")
                    Button(action: {
                        
                        try? viewModel.auth.signOut()
                        
                        
                    }, label: {Text("Kijelentkezés")})
                    .padding()
                }
                
            }
            else {
                SignInView()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}


struct SignInView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
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
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                SecureField("Jelszó", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else{
                        return
                    }
                    
                    viewModel.signIn(email: email, password: password)
                    
                }, label: { Text("Bejelentkezés")})
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding()
                HStack{
                    Text("Nincs még fiókod?")
                    Button(action: {
                       
                        //show: RegisterView
                        
                    }, label: {Text("Regisztrálj!")})
                    Spacer()
                }
            }
            Spacer()
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppViewModel())
    }
}
