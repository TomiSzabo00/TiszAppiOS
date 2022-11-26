//
//  AddScoreView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 01..
//

import SwiftUI

struct AddScoreView: View {
    @StateObject var vm = ScoresViewModelImpl(teamNum: 4)
    @State var program: String = ""
    @State var scoreTFs: [String] = ["","","","","",""]
    @State var teamNum: Int
    
    init(teamNum: Int) {
        self.teamNum = teamNum
        vm.teamNum = teamNum
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Mire adod a pontot?")
                        .padding(.leading)
                    Spacer()
                }
                TextFieldWithIcon(textField: TextField("Program neve", text: $program), imageName: "puzzlepiece.fill")
                    .padding([.leading, .trailing, .bottom])
                HStack{
                    Text("Hány pontot adsz a csapatoknak?")
                        .padding([.top, .leading])
                    Spacer()
                }
                HStack(spacing: 5){
                    Spacer()
                    ForEach(1...teamNum, id:\.self) { i in
                        Text("\(i).")
                            .lineLimit(1)
                        Spacer()
                    }
                }
                .padding(.top, 10)
                
                HStack(spacing: 5){
                    Spacer()
                    ForEach(0...teamNum-1, id:\.self) { i in
                        NumberTextField(text: $scoreTFs[i])
                    }
                    Spacer()
                }
                .padding(.top, 10)
                
                HStack{
                    Spacer()
                    Button(action: {
                        vm.uploadScore(title: program, scores: scoreTFs)

                        //reset textfields
                        program = ""
                        for i in 0...teamNum-1 {
                            scoreTFs[i] = ""
                        }
                    }, label: {
                        Text("Feltöltés")
                    })
                    .buttonStyle(ElevatedButtonStyle())
                    .padding()
                }
            }
            .padding(.top, 50)
            .onTapGesture {
                endTextEditing()
            }
            .onAppear {
                self.scoreTFs.removeAll()
                print(scoreTFs)
                for _ in 1...self.teamNum {
                    self.scoreTFs.append("")
                }
                print(scoreTFs)
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Pontok feltöltése")

    }
}

struct AddScoreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddScoreView(teamNum: 4)
        }
    }
}
