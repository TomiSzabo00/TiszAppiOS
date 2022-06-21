//
//  WordleView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 21..
//

import SwiftUI
import AlertToast

struct LetterView: View {
    
    @State var l : Letter
    @State var bg: Color
    
    var body: some View {
        
        Text(l.letter.uppercased())
            .foregroundColor(.accentColor)
            .frame(width: 50, height: 50)
            .border(Color.accentColor)
            .background(bg)
        
    }
    
}

struct WordleView: View {
    
    @StateObject var vm = WordleViewModel()
    
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
                    return Alert(title: Text("A játéknak vége"), message: Text("Nem sikerült kitalálni a megfejtést:\n\(vm.solution)"), dismissButton: .default(Text("OK")))
                case .win:
                    return Alert(title: Text("A játéknak vége"), message: Text("Gratulálok, kitaláltad a megfejtést!"), dismissButton: .default(Text("OK")))
                default:
                    return Alert(title: Text("A játéknak vége"), message: Text("Még folyamatban a játék..."), dismissButton: .default(Text("OK")))
                }
            }
        }
        //this is an external package
        /// https://github.com/elai950/AlertToast
        .toast(isPresenting: $vm.noWord){
            AlertToast(displayMode: .hud, type: .systemImage("multiply", .red), title: "Nincs ilyen magyar szó")
        }
    }
}

struct WordleView_Previews: PreviewProvider {
    static var previews: some View {
        WordleView()
    }
}
