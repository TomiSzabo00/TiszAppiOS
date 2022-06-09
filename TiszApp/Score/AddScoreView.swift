//
//  AddScoreView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 01..
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth


func SanitiseInput(input: String) -> Int{
    var correctLenghtInput = ""
    if input.count == 0 {
        return 0
    }
    if input.count > 3 {
        correctLenghtInput = String(input.prefix(3))
    } else {
        correctLenghtInput = input
    }
    return Int(correctLenghtInput) ?? 0
}


struct AddScoreView: View {
    
    @State var program: String = ""
    
    @State var scoreTFs: [String] = ["","","","","",""]
    
    @State var teamNum: Int
    
    init(teamNum: Int) {
        self.teamNum = teamNum
    }
    
    var body: some View {
        ScrollView {
            //Color.background.ignoresSafeArea()
            VStack {
                HStack {
                    Text("Mire adod a pontot?")
                        .padding(.leading)
                        //.foregroundColor(.foreground)
                    Spacer()
                }
                SimpleTextFieldWithIcon(textField: TextField("Program neve", text: $program), imageName: "puzzlepiece.fill")
                    .padding([.leading, .trailing, .bottom])
                HStack{
                Text("Hány pontot adsz a csapatoknak?")
                        .padding([.top, .leading])
                    //.foregroundColor(.foreground)
                    Spacer()
                }
                HStack(spacing: 5){
                    Spacer()
                    ForEach(1...teamNum, id:\.self) { i in
                        Text("\(i).")
                            .lineLimit(1)
                        Spacer()
                    }
                    //Spacer()
                }
                .padding(.top, 10)
                //.foregroundColor(.foreground)
                
                HStack(spacing: 5){
                    Spacer()
                    ForEach(0...teamNum-1, id:\.self) { i in
                        SimpleNumberTextField(text: $scoreTFs[i])
                    }
                    Spacer()
                }
                .padding(.top, 10)
                
                HStack{
                    Spacer()
                    Button(action: {
                        // Create Date
                        let date = Date()
                        // Create Date Formatter
                        let dateFormatter = DateFormatter()
                        // Set Date Format
                        dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
                        
                        var sanitisedScores: [Int] = []
                        for score in scoreTFs {
                            sanitisedScores.append(SanitiseInput(input: score))
                        }
                        
                        //upload sanitised inputs to fb
                        let score = ["id" : dateFormatter.string(from: date),
                                     "scores" : sanitisedScores,
                                     "name" : program,
                                     "author" : Auth.auth().currentUser?.uid ?? "unknown"] as [String: Any]
                        
                        
                        
                        Database.database().reference().child("scores").child(dateFormatter.string(from: date)).setValue(score)
                        
                        //reset textfields
                        program = ""
                        for i in 0...teamNum-1 {
                            scoreTFs[i] = ""
                        }
                        
                        
                    }, label: {
                        Text("Feltöltés")
                    })
                    .buttonStyle(SimpleButtonStyle())
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
