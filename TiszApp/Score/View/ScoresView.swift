//
//  ScoresView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 02..
//

import SwiftUI

struct ScoresView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @ObservedObject private var handler = ScoresViewModelImpl(teamNum: 4)
    
    @State private var confirmationShown = false
    
    @State private var selectedTab = 0
    
    var body: some View {
        ScoresTableView(handler: handler).environmentObject(sessionService)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Pontok megtekintése")
            .navigationBarItems(trailing: sessionService.userDetails?.admin ?? false ? Button(
                role: .destructive,
                action: { confirmationShown = true }
            ) {
                Image(systemName: "trash")
                    .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
            } : nil )
            .confirmationDialog(
                "Biztos ki akarod törölni az összes pontot?",
                isPresented: $confirmationShown,
                titleVisibility: .visible
            ) {
                Button("Igen") {
                    handler.deleteScores()
                }
            }
    }
}

struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ScoresView().environmentObject(SessionServiceImpl())
        }
    }
}
