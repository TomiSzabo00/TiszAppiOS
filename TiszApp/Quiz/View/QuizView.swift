//
//  QuizView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 09..
//

import SwiftUI

struct QuizView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @ObservedObject var handler: QuizViewModelImpl = QuizViewModelImpl()
    
    @State var isInfo: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Button(action: {
                    handler.singnal()
                }, label: {
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                })
                .background(handler.bgColor)
                .disabled(!handler.isEnabled)
            }
            
            if isInfo {
                QuizInfoAlert(shown: $isInfo)
            }
        }
        .onAppear {
            handler.userDetails = sessionService.userDetails ?? SessionUserDetails(fullName: "Error", groupNumber: -1, admin: false, uid: "error_notExistingUser")
            handler.initListeners()
        }
        .navigationTitle("AV Kvíz")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            isInfo = true
        }, label: {
            Image(systemName: "info.circle")
        }))
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView().environmentObject(SessionServiceImpl())
    }
}
