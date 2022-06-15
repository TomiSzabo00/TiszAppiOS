//
//  MultipleTextQuizAnswersView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 15..
//

import SwiftUI

struct MultipleTextQuizAnswersView: View {
    
    @State var answers: [[Answer]]
    
    var body: some View {
        List(self.answers, id: \.self) { personsAnswer in
            Section(header: Text("\(((self.answers.firstIndex(of: personsAnswer)) ?? 0)+1). kérdés")) {
                ForEach(personsAnswer, id: \.self) { i in
                    Text(i.answer)
                }
            }
        }
    }
}

struct MultipleTextQuizAnswersView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTextQuizAnswersView(answers: [[Answer(answer: "")]])
    }
}
