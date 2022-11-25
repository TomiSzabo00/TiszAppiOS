//
//  EditScoreView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 30..
//

import SwiftUI
import FirebaseDatabase

struct EditScoreView: View {
    @State var what: ScoreItem?
    @State var program: String = ""
    @State var scoreTFs: [String] = ["","","","","",""]
    @State var teamNum: Int
    
    init(what: ScoreItem?, teamNum: Int) {
        self.what = what
        self.teamNum = teamNum
    }
    
    var body: some View {
        if what != nil {
            ScrollView {
                VStack {
                    HStack {
                        Text("Program neve:").padding(.leading)
                        Spacer()
                    }
                    SimpleTextFieldWithIcon(textField: TextField("Program neve", text: $program), imageName: "puzzlepiece.fill")
                        .padding([.leading, .trailing, .bottom])
                    HStack{
                        Text("Módosítsd a pontokat:")
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
                            
                            var sanitisedScores: [Int] = []
                            for score in scoreTFs {
                                sanitisedScores.append(SanitiseInput(input: score))
                            }
                            
                            //upload sanitised inputs to db
                            let score = ["id" : what?.id ?? "noId",
                                         "scores" : sanitisedScores,
                                         "name" : program,
                                         "author" : what?.author ?? "noAuthor"] as [String: Any]
                            
                            
                            
                            Database.database().reference().child("scores").child(what?.id ?? "error").setValue(score)
                            
                            //self.presentationMode.wrappedValue.dismiss()
                            
                        }, label: {
                            Text("Szerkesztés")
                        })
                        .buttonStyle(SimpleButtonStyle())
                        .padding()
                    }
                }
                .onAppear {
                    program = what?.name ?? "error"
                    self.scoreTFs.removeAll()
                    for _ in 1...self.teamNum {
                        self.scoreTFs.append("")
                    }
                    for i in 0...teamNum-1 {
                        guard what?.scores.indices.contains(i) ?? false else { return }
                        scoreTFs[i] = String(what?.scores[i] ?? 0)
                    }
                }
                .navigationTitle("Szerkesztés")
                .navigationBarTitleDisplayMode(.inline)
            }
    }
    }
}

struct EditScoreView_Previews: PreviewProvider {
    static var previews: some View {
        EditScoreView(what: nil, teamNum: 4)
    }
}
