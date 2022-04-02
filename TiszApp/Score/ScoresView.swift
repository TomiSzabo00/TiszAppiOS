//
//  ScoresView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 02..
//

import SwiftUI
import FirebaseDatabase

struct ScoresView: View {
    
    @StateObject private var handler = ScoresHandlerImpl()
    
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Text("Csapatok pontjai")
                    .frame(maxWidth: 200, alignment: .center)
                    .padding(.trailing)
            }
            .padding()
            HStack{
                Text("Program neve")
                    .frame(maxWidth: 140, alignment: .center)
                Text("1.")
                    .frame(maxWidth: 50, alignment: .center)
                Text("2.")
                    .frame(maxWidth: 50, alignment: .center)
                Text("3.")
                    .frame(maxWidth: 50, alignment: .center)
                Text("4.")
                    .frame(maxWidth: 50, alignment: .center)
            }
            .padding()
            
            //List
            ScrollView{
                ForEach(handler.scoresList) {score in
                    HStack{
                        Text(score.name)
                            .frame(maxWidth: 140, alignment: .center)
                        Divider()
                        Text("\(score.score1)")
                            .frame(maxWidth: 50, alignment: .center)
                        Divider()
                        Text("\(score.score2)")
                            .frame(maxWidth: 50, alignment: .center)
                        Divider()
                        Text("\(score.score3)")
                            .frame(maxWidth: 50, alignment: .center)
                        Divider()
                        Text("\(score.score4)")
                            .frame(maxWidth: 50, alignment: .center)
                    }
                    .padding()
                }
            }
            //Spacer()
            //end List
            
            HStack{
                Text("Összesen:")
                    .bold()
                    .frame(maxWidth: 140, alignment: .center)
                Text("0")
                    .frame(maxWidth: 50, alignment: .center)
                Text("0")
                    .frame(maxWidth: 50, alignment: .center)
                Text("0")
                    .frame(maxWidth: 50, alignment: .center)
                Text("0")
                    .frame(maxWidth: 50, alignment: .center)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ScoresView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView{
            ScoresView()
        }
    }
}
