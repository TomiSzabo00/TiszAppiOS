//
//  HiddenWorldeView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 26..
//

import SwiftUI
import AlertToast

struct HiddenWordleView: View {
    
    @StateObject var vm = HiddenWordleViewModel(stage: 1)
    
    var body: some View {
        VStack {
            ScrollView {
            VStack(spacing: 3) {
                ForEach(0..<7) { i in
                    HStack(spacing: 3) {
                        ForEach(Array(vm.letters[i*5..<(i+1)*5]), id:\.self) { letter in
                            LetterView(l: letter, bg: vm.letterBGs[vm.letters.firstIndex(of: letter)!])
                        }
                    }
                    .padding([.leading, .trailing])
                }
            }
            }
            Spacer()
            //keyboard
            VStack(spacing: 2) {
                ForEach(0..<4) { i in
                    HStack(spacing: 2) {
                        ForEach(Array(vm.keys[i*12..<min((i+1)*12, vm.keys.count)]), id:\.self) { key in
                            Button(action: {
                                vm.nextButonPressed(key)
                            }, label: {
                                Text(key.uppercased())
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                    .contentShape(RoundedRectangle(cornerRadius: 2))
                            })
                            //.frame(maxWidth: .infinity)
                            .buttonStyle(WordleButtonStyle())
                            .background(vm.backgrounds[vm.keys.firstIndex(of: key)!])
                            .cornerRadius(2)
                            .disabled(vm.gameOver)
                        }
                    }
                    .padding([.leading, .trailing], 10)
                }
            }
            .padding(.bottom)
            .alert(isPresented: $vm.gameEnd) {
                switch vm.gameState {
                case .lose:
                    return Alert(title: Text("A játéknak vége"), message: Text("Nem sikerült kitalálni a rejtett megfejtést. Próbáld újra holnap!"), dismissButton: .default(Text("OK")))
                case .win:
                    if vm.stage < vm.solutions.count {
                    return Alert(title: Text("Szép munka"), message: Text("Én a helyedben felírnám a megfejtést ;)"), dismissButton: Alert.Button.default(Text("Tovább"), action: {
                        vm.nextStage()
                     }))
                    } else {
                        return Alert(title: Text("A játéknak vége"), message: Text("Gratulálok, kitaláltad az összes rejtett megfejtést!"), dismissButton: .default(Text("OK")))
                    }
                default:
                    return Alert(title: Text("WTF"), message: Text("Még folyamatban a játék..."), dismissButton: .default(Text("OK")))
                }
            }
        }
        .navigationBarTitle("\(self.vm.stage)/\(self.vm.solutions.count)")
        
        //this is an external package
        /// https://github.com/elai950/AlertToast
        .toast(isPresenting: $vm.noWord){
            AlertToast(displayMode: .hud, type: .systemImage("multiply", .red), title: "Nincs ilyen magyar szó")
        }
    }
}

struct HiddenWorldeView_Previews: PreviewProvider {
    static var previews: some View {
        HiddenWordleView()
    }
}
