//
//  NotificationAdminView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 18..
//

import SwiftUI

struct NotificationAdminView: View {
    
    @StateObject var vm = NotificationViewModel()
    
    @State var toUsers = true
    
    @State var toAdmins = false
    
    var body: some View {
        ScrollView {
        VStack {
            
            VStack {
                HStack {
                    Text("Kinek szeretnéd kiküldeni?")
                    Spacer()
                }
                
                Toggle(isOn: $toUsers, label: {
                    Text("Táborozóknak")
                })
                
                Toggle(isOn: $toAdmins, label: {
                    Text("Szervezőknek")
                })
            }
            .padding()
            
            
            HStack {
                Text("Értesítés részletei:")
                    .padding()
                Spacer()
            }
            
            TextField("Cím", text: $vm.title)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .autocapitalization(.sentences)
                .padding()
            
//            HStack {
//                Text("Értesítés szövege:")
//                    .padding()
//                Spacer()
//            }
            
            TextField("Tartalom", text: $vm.message)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .autocapitalization(.sentences)
                .padding()
            
            Button(action: {
                //send
                vm.sendNotification(toUsers: self.toUsers, toAdmins: self.toAdmins)
            }, label: {
                Text("Küldés")
            })
            .padding()
            .buttonStyle(SimpleButtonStyle())
        }
    }
        .navigationBarTitle("Értesítés")
        .navigationBarTitleDisplayMode(.large)
        .alert(vm.alertTitle, isPresented: $vm.isShowing) {
            Button("OK") { }
        } message: {
            Text(vm.alertMessage)
        }
    }
}

struct NotificationAdminView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationAdminView()
    }
}
