//
//  ScoresView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 02..
//

import SwiftUI

struct ScoresView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @ObservedObject private var handler = ScoresHandlerImpl(teamNum: 4)
    
    @State private var confirmationShown = false
    
    @State private var selectedTab = 0
        
    let numTabs = 2
    let minDragTranslationForSwipe: CGFloat = 50
    
    var body: some View {
        ScoresTableView(handler: handler).environmentObject(sessionService)
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Pontok megtekintése")
        .navigationBarItems(trailing: sessionService.userDetails!.admin ? Button(
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
    
    private func handleSwipe(translation: CGFloat) {
            if translation > minDragTranslationForSwipe && selectedTab > 0 {
                selectedTab -= 1
            } else  if translation < -minDragTranslationForSwipe && selectedTab < numTabs-1 {
                selectedTab += 1
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
