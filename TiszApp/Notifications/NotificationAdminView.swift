//
//  NotificationAdminView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 18..
//

import SwiftUI

struct NotificationAdminView: View {
    
    @StateObject var vm = NotificationViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Értesítés címe:")
                    .padding()
                Spacer()
            }
            TextField("Cím", text: $vm.title)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .autocapitalization(.sentences)
                .padding()
            
            HStack {
                Text("Értesítés szövege:")
                    .padding()
                Spacer()
            }
            
            TextField("Tartalom", text: $vm.message)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .autocapitalization(.sentences)
                .padding()
            
            Button(action: {
                //send
                vm.sendNotification()
            }, label: {
                Text("Küldés")
            })
            .padding()
            .buttonStyle(SimpleButtonStyle())
        }
        .navigationBarTitle("Értesítés")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct NotificationAdminView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationAdminView()
    }
}
