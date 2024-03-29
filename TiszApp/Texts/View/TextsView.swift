//
//  TextsView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 09..
//

import SwiftUI


struct TextsView: View {
    @ObservedObject var handler: TextsViewModelImpl = TextsViewModelImpl(mode: .loadTexts)
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        ScrollView {
            ForEach(handler.textInfos) { textInfo in
                NavigationLink(destination: TextDetailView(textInfo: textInfo).environmentObject(sessionService).fullBackground(),
                               label: {
                    TextItemView(title: textInfo.title, text: textInfo.text)
                        .padding(.bottom, 10)
                })
                
            }
            .padding(10)
        } //ScrollView end
        .navigationTitle("Szövegek")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct TextsView_Previews: PreviewProvider {
    static var previews: some View {
        TextsView().environmentObject(SessionServiceImpl())
    }
}

