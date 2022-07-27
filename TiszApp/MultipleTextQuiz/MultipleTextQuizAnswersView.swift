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

    var currTeam: Int
    
    var body: some View {
        
        VStack {
            
            Text("A csapat pontszáma: \((Double(vm.itemColors.filter{$0 == .green}.count) + Double(vm.itemColors.filter{$0 == .yellow}.count) / 2.0).formatted())/\(vm.itemColors.count)")
            .padding()
            
            List(self.answers, id: \.self) { personsAnswer in
                Section(header: Text("\(((self.answers.firstIndex(of: personsAnswer)) ?? 0)+1). kérdés")) {
                    ForEach(personsAnswer, id: \.self) { i in
                        Text(i.answer)
                    }
                    .listRowBackground(vm.itemColors[(self.answers.firstIndex(of: personsAnswer)) ?? 0])
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(action: {
                            // right
                            vm.itemColors[(self.answers.firstIndex(of: personsAnswer)) ?? 0] = .green
                        }, label: {
                            Image(systemName: "checkmark.circle.fill")
                        })

                        Button(action: {
                            // half right
                            vm.itemColors[(self.answers.firstIndex(of: personsAnswer)) ?? 0] = .yellow
                        }, label: {
                            Image(systemName: "plusminus.circle.fill")
                        })
                        .tint(.yellow)
                    }
                    .tint(.green)
                    
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button(action: {
                            // wrong
                            vm.itemColors[(self.answers.firstIndex(of: personsAnswer)) ?? 0] = .red
                        }, label: {
                            Image(systemName: "x.circle.fill")
                        })
                    }
                    .tint(.red)
                }
            }

            Button("Pontok mentése") {
                vm.saveScores()
            }
            .padding()
            .disabled(vm.itemColors.contains(.white))

            .navigationBarTitle("Válaszok")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            vm.currTeam = currTeam
        }
        
    }
}

struct MultipleTextQuizAnswersView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTextQuizAnswersView(vm: MultipleTextQuizViewModel(), answers: [[Answer(answer: "")]], currTeam: 0)
    }
}
