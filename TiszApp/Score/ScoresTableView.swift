//
//  ScoresTableView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 18..
//

import SwiftUI

struct ScoresTableView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @ObservedObject var handler: ScoresViewModelImpl
    
    @State var ID: Int? = nil
    @State var scoreToEdit: ScoreItem? = nil
    @State var isPicScoresShowing: Bool = true
    
    var body: some View {
        VStack{
            HStack {
                Spacer()
                    .frame(minWidth: 100, maxWidth: 140)
                Text("Csapatok pontjai")
                    .frame(minWidth: 100, maxWidth: 200)
                //.padding(.trailing)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
            }
            .padding(.trailing)
            .padding(.bottom, 10)
            
            HStack{
                Text("Program neve")
                    .frame(width:120)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                ForEach (1...sessionService.teamNum, id: \.self) { i in
                    Text("\(i).")
                        .bold()
                        .frame(maxWidth:70)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                }
                
            }
            .padding(.trailing)
            .padding(.leading, 10)
            
            //List
            List(handler.scoresList, id: \.self) { score in
                if(score.name.starts(with: "kép: ") && !self.isPicScoresShowing) {
                    EmptyView()
                } else {
                    HStack {
                        Spacer()
                        Text(score.name)
                            .frame(width:120)
                            .minimumScaleFactor(0.1)
                            .lineLimit(3)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color(.label).opacity(0.2), radius: 3, x: 0, y: 3))
                            
                        ForEach (0...sessionService.teamNum-1, id: \.self) { i in
                            Text(score.scores.indices.contains(i) ? String(score.scores[i]) : "0")
                                    .frame(maxWidth:70)
                                    .minimumScaleFactor(0.1)
                                    .lineLimit(1)
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color(.label).opacity(0.2), radius: 3, x: 0, y: 3))
                            }
                        Spacer()
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .swipeActions {
                        if sessionService.userDetails?.admin ?? false {
                            Button(role: .destructive) {
                                handler.deleteScore(score: score)
                            } label: {
                                Label("Törlés", systemImage: "trash.fill")
                            }
                            
                            Button(action: {
                                ID = 0
                                scoreToEdit = score
                            }, label: {
                                Label("Szerk.", systemImage: "pencil")
                            })
                        }
                        
                    }
                }
                    
                    
                }
            .listStyle(PlainListStyle())
            //end List
            
            NavigationLink(destination: EditScoreView(what: scoreToEdit, teamNum: sessionService.teamNum).fullBackground(), tag: 0, selection: $ID) {EmptyView()}
            
            if (self.isPicScoresShowing) {
                HStack{
                    SimpleText(text: Text("Képek:"))
                    
                    ForEach (0...sessionService.teamNum-1, id: \.self) { i in
                        Text(String(handler.picSums[i]))
                            .frame(maxWidth:70)
                            .foregroundStyle(Color.text)
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.btn)
                                    .shadow(color: Color.main, radius: 0, x: 0, y: 3))
                    }
                    
                }
                .padding([.leading, .top, .trailing], 10)
            }
            
            HStack{
                SimpleText(text: Text("Összesen:"))
                    
                ForEach (0...sessionService.teamNum-1, id: \.self) { i in
                    Text(String(handler.sums[i]))
                        .frame(maxWidth:70)
                        .foregroundStyle(Color.text)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.btn)
                                .shadow(color: Color.main, radius: 0, x: 0, y: 3))
                }
                
            }
            .padding(10)
        }
        .navigationBarTitle("Pontállás")
        .navigationBarTitleDisplayMode(.large)
        
        .navigationBarItems(trailing: Button(action: { self.isPicScoresShowing.toggle()}, label: {
            self.isPicScoresShowing ? Image(systemName: "photo.on.rectangle") : Image(systemName: "rectangle.on.rectangle.slash")
        }))
    }
}

struct ScoresTableView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresTableView(handler: ScoresViewModelImpl(teamNum: 4)).environmentObject(SessionServiceImpl())
    }
}
