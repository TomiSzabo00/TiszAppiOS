//
//  QuizView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 09..
//

import SwiftUI

struct QuizView: View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(Color("quizBarText"))]
        UINavigationBar.appearance().backgroundColor = UIColor(Color("quizBarBackground"))
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                print("pressed")
            }, label: {
                Text("")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            })
            .background(Color.blue)
        }
        
        .navigationTitle("AV Kvíz")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
