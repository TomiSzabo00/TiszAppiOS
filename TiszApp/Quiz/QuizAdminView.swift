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
                        SimpleRectangle(width: UIScreen.main.bounds.width-100, height: 80)
                        Text("Nincs első jelentkező.")
                            .frame(maxWidth: UIScreen.main.bounds.width-100, maxHeight: 80)
                            .foregroundColor(.foreground)
                    }
                    ZStack {
                        SimpleRectangle(width: UIScreen.main.bounds.width-100, height: 80)
                        Text("Nincs második jelentkező.")
                            .frame(maxWidth: UIScreen.main.bounds.width-100, maxHeight: 80)
                            .foregroundColor(.foreground)
                    }
                    ZStack {
                        SimpleRectangle(width: UIScreen.main.bounds.width-100, height: 80)
                        Text("Nincs harmadik jelentkező.")
                            .frame(maxWidth: UIScreen.main.bounds.width-100, maxHeight: 80)
                            .foregroundColor(.foreground)
                    }
                    ZStack {
                        SimpleRectangle(width: UIScreen.main.bounds.width-100, height: 80)
                        Text("Nincs negyedik jelentkező.")
                            .frame(maxWidth: UIScreen.main.bounds.width-100, maxHeight: 80)
                            .foregroundColor(.foreground)
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
        }
    }
}

struct QuizAdminView_Previews: PreviewProvider {
    static var previews: some View {
        QuizAdminView()
    }
}
