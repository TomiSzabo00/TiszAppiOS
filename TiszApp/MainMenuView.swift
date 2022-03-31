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
                Image(systemName: self.icon)
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text(self.text)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            .frame(width: 110, height: 110, alignment: .center)
            
        })
        .buttonStyle(SimpleButtonStyle())
    }
}

struct MainMenuView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    private var gridItemLayout = [GridItem(.fixed(150), spacing: 20), GridItem(.fixed(150), spacing: 20)]
    
    var body: some View {
            ZStack {
                Color.offWhite.ignoresSafeArea()
                VStack{
                    ScrollView {
                        LazyVGrid(columns: gridItemLayout, spacing: 20) {
                            ForEach($sessionService.buttonTitles, id: \.self) { $e in
                                
                                IconButton(text: e,
                                           icon: sessionService.buttonIcons[sessionService.buttonTitles.firstIndex(of: e)!],
                                           action: sessionService.buttonActions[sessionService.buttonTitles.firstIndex(of: e)!])
                                
                            }
                        } //LazyVGrid end
                        .padding([.leading, .trailing], 20)
                    } //ScrollView end
                    
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
