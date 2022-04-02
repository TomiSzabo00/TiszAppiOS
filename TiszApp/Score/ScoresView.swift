//
//  ScoresView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 02..
//

import SwiftUI

struct ScoresView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @ObservedObject private var handler = ScoresHandlerImpl()
    
    @State private var confirmationShown = false
    
    var body: some View {
        ZStack{
            Color.offWhite.ignoresSafeArea()
            VStack{
                HStack {
                    Spacer()
                    SimpleText(text: "Csapatok pontjai", maxWidth: 200)
                        .frame(maxWidth: 200, alignment: .center)
                        .padding(.trailing)
                }
                .padding(.trailing)
                .padding(.bottom, 10)
                
                HStack{
                    SimpleText(text: "Program neve", trailingPadding: 5, maxWidth: 140)
                        .frame(maxWidth: 140, alignment: .center)
                    SimpleText(text: "1.")
                        .frame(maxWidth: 50, alignment: .center)
                    SimpleText(text: "2.")
                        .frame(maxWidth: 50, alignment: .center)
                    SimpleText(text: "3.")
                        .frame(maxWidth: 50, alignment: .center)
                    SimpleText(text: "4.")
                        .frame(maxWidth: 50, alignment: .center)
                }
                .padding(.trailing)
                .padding(.leading, 5)
                
                //List
                ScrollView{
                    ForEach(handler.scoresList) {score in
                        HStack{
                            SimpleText(text: score.name, trailingPadding: 5, maxLines: 3, maxWidth: 140)
                                .frame(maxWidth: 140, alignment: .center)
                            SimpleText(text: String(score.score1))
                                .frame(maxWidth: 50, alignment: .center)
                            SimpleText(text: String(score.score2))
                                .frame(maxWidth: 50, alignment: .center)
                            SimpleText(text: String(score.score3))
                                .frame(maxWidth: 50, alignment: .center)
                            SimpleText(text: String(score.score4))
                                .frame(maxWidth: 50, alignment: .center)
                        }
                        .padding(.trailing)
                        .padding(.leading, 5)
                        .padding(.top, 10)
                        
                    }
                }
                //Spacer()
                //end List
                
                HStack{
                    SimpleText(text: "Összesen:", trailingPadding: 5, maxWidth: 140)
                    //.frame(maxWidth: 140, alignment: .center)
                    SimpleText(text: String(handler.sum1))
                        .frame(maxWidth: 60, alignment: .center)
                    SimpleText(text: String(handler.sum2))
                        .frame(maxWidth: 60, alignment: .center)
                    SimpleText(text: String(handler.sum3))
                        .frame(maxWidth: 60, alignment: .center)
                    SimpleText(text: String(handler.sum4))
                        .frame(maxWidth: 60, alignment: .center)
                }
                .padding([.top, .trailing], 10)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Pontok megtekintése")
            .navigationBarItems(trailing: sessionService.userDetails!.admin ? Button(
                role: .destructive,
                action: { confirmationShown = true }
            ) {
                Image(systemName: "trash.fill")
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
}

struct ScoresView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView{
            ScoresView().environmentObject(SessionServiceImpl())
        }
    }
}
