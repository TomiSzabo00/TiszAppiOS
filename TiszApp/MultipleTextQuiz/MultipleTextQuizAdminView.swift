//
//  MultipleTextQuizAdminView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 14..
//

import SwiftUI

struct MultipleTextQuizAdminView: View {
    
    @StateObject var vm = MultipleTextQuizViewModel()
    
    @State var numText: String = "0"
    
    var body: some View {
        if(vm.numOfQuestions == 0) {
            VStack {
                
                Text("Hány kérdés legyen?")
                Text("(min. 1, max. 50)")
                    .padding(.bottom)
                
                HStack {
                    Button(action: {
                        self.numText = String((Int(self.numText) ?? 1) - 1)
                        if (Int(self.numText) ?? -1 < 0) {
                            self.numText = "0"
                        }
                        if(Int(self.numText) ?? 51 > 50) {
                            self.numText = "50"
                        }
                    }, label: {
                        Image(systemName: "minus")
                    })
                    .disabled(Int(self.numText) ?? 0 <= 0)
                    
                    SimpleNumberTextField(text: $numText)
                        .frame(maxWidth: 100)
                    
                    Button(action: {
                        self.numText = String((Int(self.numText) ?? -1) + 1)
                        if (Int(self.numText) ?? -1 < 0) {
                            self.numText = "0"
                        }
                        if(Int(self.numText) ?? 51 > 50) {
                            self.numText = "50"
                        }
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .disabled(Int(self.numText) ?? 50 >= 50)
                }
                .padding()
                
                Button(action: {
                    vm.setNumOfQuestions(num: Int(self.numText) ?? 1)
                }, label: {
                    Text("Indítás")
                })
                .disabled((Int(self.numText) ?? 0 <= 0) || (Int(self.numText) ?? 50 >= 50))
                .padding()
                
            }//vstack end
        } else {
            Text("\(vm.numOfQuestions) darab kérdés feltéve.")
        }
    }
}

struct MultipleTextQuizAdminView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTextQuizAdminView()
    }
}
