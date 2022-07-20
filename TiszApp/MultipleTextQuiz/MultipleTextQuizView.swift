//
//  MultipleTextQuizView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 15..
//

import SwiftUI

struct MultipleTextQuizView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @StateObject var vm = MultipleTextQuizViewModel()
    
    @State var areYouSure = false
    
    var body: some View {
        if(vm.numOfQuestions > 0 && vm.canUpload) {
            ScrollView {
                Text("Az alábbi mezőkbe írhatod a válaszokat, sorrendben.")
                    .padding()
                ForEach(0...vm.numOfQuestions-1, id: \.self) { i in
                    SimpleTextField(textField: TextField("\(i+1). válasz", text: $vm.answers[i].answer))
                        .padding()
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        //submit
                        self.areYouSure = true
                    }, label: {
                        Text("Beadás")
                    })
                    .buttonStyle(SimpleButtonStyle())
                }
                .padding()

                .confirmationDialog("Biztos vagy benne?", isPresented: $areYouSure, actions: {
                    Button("Igen!") {
                        vm.sumbitAnswers()
                    }
                    Button("Nem", role: .cancel) { }
                }, message: {
                    Text("Biztosan beküldöd a válaszokat?")
                })
                .alert(isPresented: $vm.errorAlert, content: {
                    return Alert(title: Text("Hiba"),
                                 message: Text("Valami hiba történt..."))
                })
            }
            .onAppear {
                self.vm.sessionService = self.sessionService
                vm.initUploadListener()
            }
            .navigationTitle("Kvíz 2")
            .navigationBarTitleDisplayMode(.large)
        } else {
            Text("Még nincs feltéve egy kérdés sem, vagy már adtál be választ.")
                .padding()
                .onAppear {
                    self.vm.sessionService = self.sessionService
                    vm.initUploadListener()
                }
                .navigationTitle("Kvíz 2")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct MultipleTextQuizView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTextQuizView()
    }
}
