//
//  ScoresTableView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 18..
//

import SwiftUI

struct ScoresTableView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @ObservedObject var handler: ScoresHandlerImpl
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()
            VStack{
                HStack {
                    Spacer()
                        .frame(minWidth: 100, maxWidth: 140)
                    SimpleText(text: "Csapatok pontjai", maxWidth: 200)
                        .frame(minWidth: 100)
                        .padding(.trailing)
                }
                .padding(.trailing)
                .padding(.bottom, 10)
                
                HStack{
                    SimpleText(text: "Program neve", trailingPadding: 5, maxWidth: 140)
                        .frame(minWidth: 100)
                    SimpleText(text: "1.", maxWidth: 50, isBold: true)
                    SimpleText(text: "2.", maxWidth: 50, isBold: true)
                    SimpleText(text: "3.", maxWidth: 50, isBold: true)
                    SimpleText(text: "4.", maxWidth: 50, isBold: true)
                }
                .padding(.trailing)
                .padding(.leading, 5)
                
                //List
                ScrollView{
                    ForEach(handler.scoresList) {score in
                        HStack{
                            SimpleText(text: score.name, trailingPadding: 5, maxLines: 3, maxWidth: 140)
                                .frame(minWidth: 100)
                            SimpleText(text: String(score.score1), maxWidth: 50)
                            SimpleText(text: String(score.score2), maxWidth: 50)
                            SimpleText(text: String(score.score3), maxWidth: 50)
                            SimpleText(text: String(score.score4), maxWidth: 50)
                        }
                        .padding(.trailing)
                        .padding(.leading, 5)
                        .padding(.top, 10)
                        
                    }
                }
                //Spacer()
                //end List
                
                HStack{
                    SimpleText(text: "Összesen:", trailingPadding: 5, maxWidth: 140, isBold: true, isGradient: true)
                        .frame(minWidth: 100)
                    SimpleText(text: String(handler.sum1), maxWidth: 50)
                    SimpleText(text: String(handler.sum2), maxWidth: 50)
                    SimpleText(text: String(handler.sum3), maxWidth: 50)
                    SimpleText(text: String(handler.sum4), maxWidth: 50)
                }
                .padding([.top, .trailing], 10)
            }
        }
    }
}

struct ScoresTableView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresTableView(handler: ScoresHandlerImpl()).environmentObject(SessionServiceImpl())
    }
}
