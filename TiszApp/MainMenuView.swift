//
//  MainMenuView.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 25..
//

import SwiftUI
import FirebaseAuth

struct IconButton: View {
    private var text: String
    private var icon: String
    private var action: () -> Void
    
    init(text: String, icon: String, action: @escaping () -> Void) {
        self.text = text
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: self.action, label: {
            VStack{
                LinearGradient(Color.gradientLight, Color.gradientDark)
                    .mask(
                Image(systemName: self.icon)
                    .resizable()
                    .scaledToFit()
                    .padding([.leading, .trailing, .top])
                    .padding(.bottom, 10))
                    .frame(maxWidth: 80, maxHeight: 80)
                    //.shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 5)
                Text(self.text)
                    .bold()
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.1)
                    //.foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
            }
            .padding()
            .frame(width: min(UIScreen.main.bounds.width/2-40,UIScreen.main.bounds.height/2-40), height: min(UIScreen.main.bounds.width/2-40,UIScreen.main.bounds.height/2-40), alignment: .center)
            
        })
        //.padding()
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color(.systemBackground))
            .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
        //.buttonStyle(SimpleButtonStyle())
    }
}

struct MainMenuView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State var ID: Int? = nil
    
    private var gridItemLayout = [GridItem(.fixed(UIScreen.main.bounds.width/2-40), spacing: 20), GridItem(.fixed(UIScreen.main.bounds.width/2-40), spacing: 20)]
    
    var body: some View {
        ZStack {
            //Color.background.ignoresSafeArea()
            VStack{
                
                ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach($sessionService.buttonTitles, id: \.self) { $e in
                            if(sessionService.btnStates[sessionService.buttonTitles.firstIndex(of: e)!] || sessionService.userDetails?.admin ?? false) {
                                IconButton(text: e,
                                           icon: sessionService.buttonIcons[sessionService.buttonTitles.firstIndex(of: e)!],
                                           action: { ID = sessionService.buttonTitles.firstIndex(of: e)! })
                            }

                        }
                    } //LazyVGrid end
                    //.padding([.leading, .trailing], 20)
                    .padding([.top, .bottom])
                } //ScrollView end
                
                NavigationLink(destination: UploadView(), tag: 0, selection: $ID) {EmptyView()}
                
                NavigationLink(destination: ScoresTableView(handler: ScoresHandlerImpl()).environmentObject(sessionService), tag: 1, selection: $ID) {EmptyView()}
                
                
                
                if (sessionService.userDetails?.admin != nil) && sessionService.userDetails?.admin == true {
                    NavigationLink(destination: QuizAdminView(), tag: 2, selection: $ID) {EmptyView()}
                } else {
                    NavigationLink(destination: QuizView().environmentObject(sessionService), tag: 2, selection: $ID) {EmptyView()}
                }
                    
                NavigationLink(destination: ImagesView(checkImages: false).environmentObject(sessionService), tag: 3, selection: $ID) {EmptyView()}
                
                NavigationLink(destination: TextsView().environmentObject(sessionService), tag: 4, selection: $ID) {EmptyView()}
                
                NavigationLink(destination: ImagesView(checkImages: true).environmentObject(sessionService), tag: 5, selection: $ID) {EmptyView()}
                
                NavigationLink(destination: AddScoreView(), tag: 6, selection: $ID) {EmptyView()}
                
                Button(action: {
                    
                    sessionService.logout()
                    
                }, label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                        Text("Kijelentkezés")
                    }
                })
                .padding()
                //.buttonStyle(SimpleButtonStyle())
                
            }
        }
        .navigationBarHidden(true)
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainMenuView().environmentObject(SessionServiceImpl())
        }
    }
}
