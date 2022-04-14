//
//  QuizAdminView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 09..
//

import SwiftUI

struct QuizAdminView: View {
    
    @ObservedObject var handler: QuizHandlerImpl = QuizHandlerImpl()
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                VStack(spacing: 20) {
                    ZStack {
                        
                        SimpleRectangle(width: UIScreen.main.bounds.width-100, height: 80, bg: handler.rt0BG)
                        
                        Text(handler.texts[0])
                            .bold()
                            .foregroundColor(handler.text0Color)
                            .frame(maxWidth: UIScreen.main.bounds.width-100, maxHeight: 80)
                    }
                    ZStack {
                        SimpleRectangle(width: UIScreen.main.bounds.width-100, height: 80, bg: handler.rt1BG)
                        Text(handler.texts[1])
                            .bold()
                            .frame(maxWidth: UIScreen.main.bounds.width-100, maxHeight: 80)
                            .foregroundColor(handler.text1Color)
                    }
                    ZStack {
                        SimpleRectangle(width: UIScreen.main.bounds.width-100, height: 80, bg: handler.rt2BG)
                        Text(handler.texts[2])
                            .bold()
                            .frame(maxWidth: UIScreen.main.bounds.width-100, maxHeight: 80)
                            .foregroundColor(handler.text2Color)
                    }
                    ZStack {
                        SimpleRectangle(width: UIScreen.main.bounds.width-100, height: 80, bg: handler.rt3BG)
                        Text(handler.texts[3])
                            .bold()
                            .frame(maxWidth: UIScreen.main.bounds.width-100, maxHeight: 80)
                            .foregroundColor(handler.text3Color)
                    }
                }
                .padding()
                VStack(spacing: 20) {
                    Button(action: {
                        //reset
                        handler.reset()
                    }, label: {
                        Text("Visszaállít")
                    })
                    .buttonStyle(SimpleButtonStyle())
                    
                    Button(action: {
                        //disable
                        handler.disable()
                    }, label: {
                        Text("Letilt")
                    })
                    .buttonStyle(SimpleButtonStyle())
                }
            }
            .onAppear {
                handler.userDetails = SessionUserDetails(fullName: "", groupNumber: -1, admin: false, uid: "")
                handler.initListeners()
            }
        }
    } // body end
}

struct QuizAdminView_Previews: PreviewProvider {
    static var previews: some View {
        QuizAdminView()
    }
}
