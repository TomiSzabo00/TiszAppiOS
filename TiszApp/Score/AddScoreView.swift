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
    
    @State var firstScore: String = ""
    @State var secondScore: String = ""
    @State var thirdScore: String = ""
    @State var fourthScore: String = ""
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            VStack {
                HStack {
                    Text("Mire adod a pontot?")
                        .padding(.leading)
                        .foregroundColor(.offBlack)
                    Spacer()
                }
                SimpleTextFieldWithIcon(textField: TextField("Program neve", text: $program), imageName: "puzzlepiece.fill")
                    .padding([.leading, .trailing, .bottom])
                HStack{
                Text("Hány pontot adsz a csapatoknak?")
                        .padding([.top, .leading])
                    .foregroundColor(.offBlack)
                    Spacer()
                }
                HStack(spacing: 30){
                    Spacer()
                    Text("1.")
                    Spacer()
                    Text("2.")
                    Spacer()
                    Text("3.")
                    Spacer()
                    Text("4.")
                    Spacer()
                }
                .padding(.top, 10)
                .foregroundColor(.offBlack)
                
                HStack(spacing: 5){
                    Spacer()
                    SimpleNumberTextField(text: $firstScore)
                    Spacer()
                    SimpleNumberTextField(text: $secondScore)
                    Spacer()
                    SimpleNumberTextField(text: $thirdScore)
                    Spacer()
                    SimpleNumberTextField(text: $fourthScore)
                    Spacer()
                }
                .padding(.top, 10)
                
                HStack{
                    Spacer()
                    Button(action: {
                        
                        //upload sanitised inputs to fb
                        let score = ["score1" : SanitiseInput(input: firstScore),
                                     "score2" : SanitiseInput(input: secondScore),
                                     "score3" : SanitiseInput(input: thirdScore),
                                     "score4" : SanitiseInput(input: fourthScore),
                                     "name" : program,
                                     "author" : Auth.auth().currentUser?.uid] as [String: Any]
                        
                        // Create Date
                        let date = Date()
                        // Create Date Formatter
                        let dateFormatter = DateFormatter()
                        // Set Date Format
                        dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
                        
                        Database.database().reference().child("scores").child(dateFormatter.string(from: date)).setValue(score)
                        
                        //reset textfields
                        program = ""
                        firstScore = ""
                        secondScore = ""
                        thirdScore = ""
                        fourthScore = ""
                        
                        
                    }, label: {
                        Text("Feltöltés")
                    })
                    .buttonStyle(SimpleButtonStyle())
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Pontok feltöltése")
    }
}

struct AddScoreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddScoreView()
        }
    }
}
