//
//  ScoresTableView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 18..
//

import SwiftUI

struct ScoresTableView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @ObservedObject var handler: ScoresHandlerImpl
    
    @State var ID: Int? = nil
    
    @State var scoreToEdit: ScoreItem? = nil
    
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
                    .frame(minWidth: 100, maxWidth:140)
                //.padding(.trailing, 5)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                Text("1.")
                    .bold()
                    .frame(maxWidth:50)
                //.padding(.trailing, 5)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                Text("2.")
                    .bold()
                    .frame(maxWidth:50)
                //.padding(.trailing, 5)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                Text("3.")
                    .bold()
                    .frame(maxWidth:50)
                //.padding(.trailing, 5)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                Text("4.")
                    .bold()
                    .frame(maxWidth:50)
                //.padding(.trailing, 5)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
            }
            .padding(.trailing)
            .padding(.leading, 10)
            
            //List
            List(handler.scoresList, id: \.self) {score in
                    HStack {
                        Text(score.name)
                            .frame(minWidth: 100, maxWidth:140)
                            .minimumScaleFactor(0.1)
                            .lineLimit(3)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color(.label).opacity(0.2), radius: 3, x: 0, y: 3))
                        Text(String(score.score1))
                            .frame(maxWidth:50)
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color(.label).opacity(0.2), radius: 3, x: 0, y: 3))
                        Text(String(score.score2))
                            .frame(maxWidth:50)
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color(.label).opacity(0.2), radius: 3, x: 0, y: 3))
                        Text(String(score.score3))
                            .frame(maxWidth:50)
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color(.label).opacity(0.2), radius: 3, x: 0, y: 3))
                        Text(String(score.score4))
                            .frame(maxWidth:50)
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color(.label).opacity(0.2), radius: 3, x: 0, y: 3))
                    }
                    .listRowSeparator(.hidden)
                    .swipeActions {
                        if sessionService.userDetails!.admin {
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
            .listStyle(PlainListStyle())
            //end List
            
            NavigationLink(destination: EditScoreView(what: scoreToEdit), tag: 0, selection: $ID) {EmptyView()}
            
            HStack{
                Text("Összesen:")
                    .bold()
                    .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
                    .frame(minWidth: 100, maxWidth: 130)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                Text(String(handler.sum1))
                    .frame(maxWidth:50)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                Text(String(handler.sum2))
                    .frame(maxWidth:50)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                Text(String(handler.sum3))
                    .frame(maxWidth:50)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
                Text(String(handler.sum4))
                    .frame(maxWidth:50)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
            }
            .padding(10)
        }
        .navigationBarTitle("Pontállás")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ScoresTableView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresTableView(handler: ScoresHandlerImpl()).environmentObject(SessionServiceImpl())
    }
}
