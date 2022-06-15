//
//  MultipleTextQuizAnswersView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 15..
//

import SwiftUI

struct MultipleTextQuizAnswersView: View {
    
    @StateObject var vm : MultipleTextQuizViewModel
    
    @State var answers: [[Answer]]
    
    init(vm: MultipleTextQuizViewModel, answers: [[Answer]]) {
        _vm = StateObject(wrappedValue: vm)
        self.answers = answers
        
        //UITableView.appearance().backgroundColor = .secondarySystemBackground
    }
    
    var body: some View {
        List(self.answers, id: \.self) { personsAnswer in
            Section(header: Text("\(((self.answers.firstIndex(of: personsAnswer)) ?? 0)+1). kérdés")) {
                ForEach(personsAnswer, id: \.self) { i in
                    Text(i.answer)
                }
                .listRowBackground(vm.itemColors[(self.answers.firstIndex(of: personsAnswer)) ?? 0])
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(action: {
                        //right
                        vm.itemColors[(self.answers.firstIndex(of: personsAnswer)) ?? 0] = .green
                    }, label: {
                        Image(systemName: "checkmark.circle.fill")
                    })
                }
                .tint(.green)
                
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button(action: {
                        //wrong
                        vm.itemColors[(self.answers.firstIndex(of: personsAnswer)) ?? 0] = .red
                    }, label: {
                        Image(systemName: "x.circle.fill")
                    })
                }
                .tint(.red)
            }
        }
        
    }
}

struct MultipleTextQuizAnswersView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTextQuizAnswersView(vm: MultipleTextQuizViewModel(), answers: [[Answer(answer: "")]])
    }
}
