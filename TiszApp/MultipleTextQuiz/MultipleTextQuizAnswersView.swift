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
    
    var body: some View {
        
        VStack {
            
            Text("A csapat pontszáma: \(vm.itemColors.filter{$0 == .green}.count)/\(vm.itemColors.count)")
                .padding()
            
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
            .navigationBarTitle("Válaszok")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct MultipleTextQuizAnswersView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTextQuizAnswersView(vm: MultipleTextQuizViewModel(), answers: [[Answer(answer: "")]])
    }
}