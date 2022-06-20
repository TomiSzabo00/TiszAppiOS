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
                
                .alert(isPresented: $areYouSure, content: {
                    return Alert(title: Text("Biztos vagy benne?"),
                                 message: Text("Biztosan be szeretnéd adni a válaszaidat?"),
                                 primaryButton: Alert.Button.default(Text("Igen!"), action: {
                                    //submit
                                    self.vm.sumbitAnswers()
                                 }),
                                 secondaryButton: Alert.Button.destructive(Text("Nem"), action: {
                                    //do nothing
                                 })
                    )
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
