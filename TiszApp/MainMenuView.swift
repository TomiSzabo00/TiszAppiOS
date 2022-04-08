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
                LinearGradient(Color.gradientDark, Color.gradientLight)
                    .mask(
                Image(systemName: self.icon)
                    .resizable()
                    .scaledToFit()
                    .padding())
                Text(self.text)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
            }
            .frame(maxWidth: 110, minHeight: 110, maxHeight: 110, alignment: .center)
            
        })
        .buttonStyle(SimpleButtonStyle())
    }
}

struct MainMenuView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State var ID: Int? = nil
    
    private var gridItemLayout = [GridItem(.fixed(150), spacing: 20), GridItem(.fixed(150), spacing: 20)]
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack{
                ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach($sessionService.buttonTitles, id: \.self) { $e in
                            
                                IconButton(text: e,
                                           icon: sessionService.buttonIcons[sessionService.buttonTitles.firstIndex(of: e)!],
                                           action: { ID = sessionService.buttonTitles.firstIndex(of: e)! })
                            
                        }
                    } //LazyVGrid end
                    .padding([.leading, .trailing], 20)
                } //ScrollView end
                
                NavigationLink(destination: ImageUploadView(), tag: 0, selection: $ID) {EmptyView()}
                
                NavigationLink(destination: ScoresView().environmentObject(sessionService), tag: 1, selection: $ID) {EmptyView()}
                
                NavigationLink(destination: Text("Sportok"), tag: 2, selection: $ID) {EmptyView()}
                
                NavigationLink(destination: Text("AV Kvíz"), tag: 3, selection: $ID) {EmptyView()}
                
                NavigationLink(destination: ImagesView().environmentObject(sessionService), tag: 4, selection: $ID) {EmptyView()}
                
                NavigationLink(destination: Text("Szövegek megtekintése"), tag: 5, selection: $ID) {EmptyView()}
                
                NavigationLink(destination: Text("Képek ellenőrzése"), tag: 6, selection: $ID) {EmptyView()}
                
                NavigationLink(destination: AddScoreView(), tag: 7, selection: $ID) {EmptyView()}
                
                Button(action: {
                    
                    sessionService.logout()
                    
                }, label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                        Text("Kijelentkezés")
                    }
                })
                .padding()
                .buttonStyle(SimpleButtonStyle())
                
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
