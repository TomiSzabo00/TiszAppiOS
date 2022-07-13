//
//  ProfileView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 16..
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @StateObject var vm = ProfileViewModel(groupNum: -1, name: "")
    
    var body: some View {
        VStack {
            HStack {
                Text("Név: \(sessionService.userDetails?.fullName ?? "N/A")")
                Spacer()
            }
            .padding()
            HStack {
                if (sessionService.userDetails?.admin ?? false) {
                    Text("Csapat: Szervező")
                } else {
                    Text("Csapat: \(sessionService.userDetails?.groupNumber ?? -1)")
                }
                Spacer()
            }
            .padding([.leading, .trailing])
            
            List(vm.user, children: \.teammates) { mate in
                Text(mate.name)
                    .listRowBackground(Color.main)
            }
            .listStyle(.plain)
            
            Spacer()
            
            Button(action: {
                sessionService.logout()
            }, label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                    Text("Kijelentkezés")
                }
            })
            .buttonStyle(SimpleButtonStyle())
            .padding()

            Button("Crash") {
                fatalError("Crash was triggered")
            }
        }
        .onAppear {
            self.vm.groupNum = sessionService.userDetails?.groupNumber ?? -1
            self.vm.name = sessionService.userDetails?.fullName ?? ""
            self.vm.getTeammates()
        }
        
        .navigationTitle("Profilom")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
