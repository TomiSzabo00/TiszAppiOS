//
//  MultipleTextQuizAdminView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 14..
//

import SwiftUI

struct MultipleTextQuizAdminView: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    
    @StateObject var vm = MultipleTextQuizViewModel()
    
    @State var numText: String = "0"
    
    @State var areYouSure = false
    
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
            VStack {
                Spacer()
                Text("\(vm.numOfQuestions) darab kérdés feltéve.")
                    .padding()
                    .padding(.bottom, 50)
                
                HStack {
                    Text("Beérkezett válaszok listája:")
                    Spacer()
                }
                .padding(.leading)
                
                List(vm.allAnswers, id: \.self) { group in
                    if !group.isEmpty {
                        NavigationLink("\(((vm.allAnswers.firstIndex(of: group)) ?? 0)+1). csapat válasza(i)", destination: MultipleTextQuizAnswersView(vm: self.vm, answers: group))
                    }
                }
                .padding([.leading, .trailing])
                
                Spacer()
                Button(action: {
                    self.areYouSure = true
                }, label: {
                    Text("Visszaállítás")
                        .padding()
                })
            }
            .onAppear {
                vm.sessionService = self.sessionService
                vm.getAllAnswers()
            }
            .alert(isPresented: $areYouSure, content: {
                return Alert(title: Text("Biztos vagy benne?"),
                             message: Text("Biztosan vissza akarod állítani a kérdéseket és válaszokat?"),
                             primaryButton: Alert.Button.destructive(Text("Igen"), action: {
                                //submit
                                self.vm.removeNumOfQuestions()
                             }),
                             secondaryButton: Alert.Button.cancel(Text("Nem"), action: {
                                //do nothing
                             })
                )
            })
        }
    }
}

struct MultipleTextQuizAdminView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTextQuizAdminView()
    }
}
