//
//  QuizAdminView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 09..
//

import SwiftUI

struct QuizAdminView: View {
    @ObservedObject var handler: QuizViewModelImpl = QuizViewModelImpl()
    
    @State var teamNum: Int
    
    init(teamNum: Int) {
        self.teamNum = teamNum
        handler.teamNum = self.teamNum
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 20) {
                    ForEach((0...teamNum-1), id: \.self) { i in
                        ZStack {
                            SimpleRectangle(width: UIScreen.main.bounds.width-100, height: 80, bg: handler.rtBGs[i])
                            Text(handler.texts[i])
                                .bold()
                                .foregroundColor(handler.textColors[i])
                                .frame(maxWidth: UIScreen.main.bounds.width-100, maxHeight: 80)
                                .padding()
                                .multilineTextAlignment(.center)
                                .frame(width: UIScreen.main.bounds.width-100, height: 80)
                        }
                    }
                }
                .padding()
                HStack(spacing: 20) {
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
                .padding(.bottom)
            }
            .navigationTitle("AV Quiz")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                handler.userDetails = SessionUserDetails(fullName: "", groupNumber: -1, admin: false, uid: "")
                handler.initListeners()
            }
        }
    }
}

struct QuizAdminView_Previews: PreviewProvider {
    static var previews: some View {
        QuizAdminView(teamNum: 4)
    }
}
