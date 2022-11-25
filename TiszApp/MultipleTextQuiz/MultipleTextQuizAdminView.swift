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

    @State private var navID: Int? = 0
    
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
                .buttonStyle(SimpleButtonStyle())

                Text("vagy")
                    .padding()
                Button("Mentett válaszok betöltése") {
                    vm.getSaves()
                    navID = 1
                }
                .padding()
                .onAppear {
                    vm.sessionService = self.sessionService
                }

                NavigationLink(destination: SavesView(vm: vm), tag: 1, selection: $navID) { EmptyView() }
                
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
                        NavigationLink("\(((vm.allAnswers.firstIndex(of: group)) ?? 0)+1). csapat válasza(i)", destination: MultipleTextQuizAnswersView(vm: vm, answers: group, currTeam: (vm.allAnswers.firstIndex(of: group) ?? 0)+1))
                    }
                }
                .padding([.leading, .trailing])
                
                Spacer()

                Button("Válaszok mentése majd törlése") {
                    vm.saveAnswers()
                }
                .padding()
                .disabled(vm.allAnswers.isEmpty)

                Button(action: {
                    self.areYouSure = true
                }, label: {
                    Text("Visszaállítás")
                        .padding()
                })
                .padding()
            }
            .onAppear {
                vm.sessionService = self.sessionService
                vm.getAllAnswers()
                vm.resetItemColor()
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
