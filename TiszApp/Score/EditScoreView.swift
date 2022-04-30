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
    
    @State var firstScore: String = ""
    @State var secondScore: String = ""
    @State var thirdScore: String = ""
    @State var fourthScore: String = ""
    @State var program: String = ""
    
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
                    HStack(spacing: 28){
                        Spacer()
                        Text("1.")
                            .lineLimit(1)
                        Spacer()
                        Text("2.")
                            .lineLimit(1)
                        Spacer()
                        Text("3.")
                            .lineLimit(1)
                        Spacer()
                        Text("4.")
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding(.top, 10)
                    //.foregroundColor(.foreground)
                    
                    HStack{
                        Spacer()
                        SimpleNumberTextField(text: $firstScore)
                            .frame(width: UIScreen.main.bounds.width/4-15)
                        Spacer()
                        SimpleNumberTextField(text: $secondScore)
                            .frame(width: UIScreen.main.bounds.width/4-15)
                        Spacer()
                        SimpleNumberTextField(text: $thirdScore)
                            .frame(width: UIScreen.main.bounds.width/4-15)
                        Spacer()
                        SimpleNumberTextField(text: $fourthScore)
                            .frame(width: UIScreen.main.bounds.width/4-15)
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            
                            //upload sanitised inputs to db
                            let score = ["id" : what!.id,
                                         "score1" : SanitiseInput(input: firstScore),
                                         "score2" : SanitiseInput(input: secondScore),
                                         "score3" : SanitiseInput(input: thirdScore),
                                         "score4" : SanitiseInput(input: fourthScore),
                                         "name" : program,
                                         "author" : what!.author] as [String: Any]
                            
                            
                            
                            Database.database().reference().child("scores").child(what!.id).setValue(score)
                            
                            
                        }, label: {
                            Text("Szerkesztés")
                        })
                        .buttonStyle(SimpleButtonStyle())
                        .padding()
                    }
                }
                .onAppear {
                    firstScore = String(what!.score1)
                    secondScore = String(what!.score2)
                    thirdScore = String(what!.score3)
                    fourthScore = String(what!.score4)
                    program = what!.name
                }
                .navigationTitle("Szerkesztés")
                .navigationBarTitleDisplayMode(.inline)
            }
    }
    }
}

struct EditScoreView_Previews: PreviewProvider {
    static var previews: some View {
        EditScoreView()
    }
}
