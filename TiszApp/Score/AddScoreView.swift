//
//  AddScoreView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 01..
//

import SwiftUI

func SanitiseInput(input: String) -> Int{
    var correctLenghtInput = ""
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
                        print(SanitiseInput(input: firstScore))
                        
                        
                    }, label: {
                        Text("Feltöltés")
                    })
                    .buttonStyle(SimpleButtonStyle())
                    .padding()
                }
            }
        }
    }
}

struct AddScoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddScoreView()
    }
}
