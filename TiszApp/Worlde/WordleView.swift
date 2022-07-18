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
    var bg: Color
    var degrees: Double
    
    var body: some View {
        ZStack {
            Rectangle()
                .strokeBorder(Color.accentColor, lineWidth: 1)
                .background(Rectangle().fill(bg))
                .frame(width: 50, height: 50)
                .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))

            Text(l.letter.uppercased())
                .foregroundColor(.accentColor)
                .frame(width: 50, height: 50)
        }
    }
    
}

struct WordleView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @StateObject var vm = WordleViewModel()
    
    @State var ID: Int? = nil
    
    var body: some View {
        VStack {
            ScrollView {
            VStack(spacing: 3) {
                ForEach(0..<7) { i in
                    HStack(spacing: 3) {
                        ForEach(Array(vm.letters[i*5..<(i+1)*5]), id:\.self) { letter in
                            LetterView(l: letter, bg: vm.letterBGs[vm.letters.firstIndex(of: letter) ?? 0], degrees: vm.letterRotationss[vm.letters.firstIndex(of: letter) ?? 0])
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
                            .background(vm.backgrounds[vm.keys.firstIndex(of: key) ?? 0])
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
                    return Alert(title: Text("A játéknak vége"), message: Text("Nem sikerült kitalálni a megfejtést:\n\(vm.solution.uppercased())"),
                                 dismissButton: .default(Text("OK")))
                case .win:
                    return Alert(title: Text("A játéknak vége"), message: Text("Gratulálok, kitaláltad a megfejtést!"),
                                 dismissButton: Alert.Button.default(Text("OK"), action: {
                        //check if player can see the hidden screen
                        if (vm.canSeeHidden) {
                            ID = 1
                        }
                     }))
                default:
                    return Alert(title: Text("WTF"), message: Text("Még folyamatban a játék..."), dismissButton: .default(Text("OK")))
                }
            }
            
            NavigationLink(destination: HiddenWordleView(), tag: 1, selection: $ID) { EmptyView() }

            NavigationLink(destination: WordleHowTo().fullBackground(), tag: 2, selection: $ID) { EmptyView() }
        }
        .navigationBarItems(trailing: Button(action: {
            ID = 2
        }, label: {
            Image(systemName: "questionmark.circle")
        }))
        .onAppear {
            self.vm.sessionService = sessionService
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
