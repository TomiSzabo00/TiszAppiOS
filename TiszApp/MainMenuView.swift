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
                    .padding([.leading, .trailing, .top])
                    .padding(.bottom, 10)//)
                    .frame(maxWidth: 80, maxHeight: 80)
                Text(self.text)
                    .bold()
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.1)
            }
            .frame(width: min(UIScreen.main.bounds.width/2-70,UIScreen.main.bounds.height/2-70), height: min(UIScreen.main.bounds.width/2-70,UIScreen.main.bounds.height/2-70), alignment: .center)
            
        })
        .buttonStyle(SimpleButtonStyle())
    }
}

struct MainMenuView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State var ID: Int? = nil
    
    @State var root : UIViewController!
    @StateObject var adVm = AdsViewModel()
    
    private var gridItemLayout = [GridItem(.fixed(UIScreen.main.bounds.width/2-20)), GridItem(.fixed(UIScreen.main.bounds.width/2-20))]
    
    var body: some View {
        ZStack {
            VStack{
                ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 40) {
                        if sessionService.userDetails?.groupNumber != 99 {
                            ForEach($sessionService.buttonTitles, id: \.self) { $e in
                                if(sessionService.btnStates[sessionService.buttonTitles.firstIndex(of: e) ?? 0] || sessionService.userDetails?.admin ?? false) {
                                    IconButton(text: e,
                                               icon: sessionService.buttonIcons[sessionService.buttonTitles.firstIndex(of: e) ?? 0],
                                               action: { ID = sessionService.buttonTitles.firstIndex(of: e) ?? 0 })
                                }

                            }
                        }
                        
                        IconButton(text: "Támogasd a fejlesztőket", icon: "dollarsign.circle.fill", action: {
                            adVm.loadRewardedAd(root: self.root)
                        })
                        .onAppear {
                            self.root = UIApplication.shared.windows.first?.rootViewController
                        }
                        .alert(isPresented: $adVm.showAlert, content: {
                            adVm.displayAlert()
                        })
                    } //LazyVGrid end
                    .padding([.top, .bottom])
                } //ScrollView end
                
                Group {
                    Group {
                        NavigationLink(destination: ScheduleView().fullBackground(), tag: 0, selection: $ID) {EmptyView()}
                        
                        NavigationLink(destination: ScoresTableView(handler: ScoresViewModelImpl(teamNum: sessionService.teamNum)).environmentObject(sessionService).fullBackground(), tag: 1, selection: $ID) {EmptyView()}

                        NavigationLink(destination: WordleView().environmentObject(sessionService).fullBackground(), tag: 2, selection: $ID) {EmptyView()}

                        NavigationLink(destination: UploadView(), tag: 3, selection: $ID) {EmptyView()}

                        NavigationLink(destination: ImagesView(checkImages: false).environmentObject(sessionService).fullBackground(), tag: 4, selection: $ID) {EmptyView()}

                        NavigationLink(destination: SongsView().fullBackground(), tag: 5, selection: $ID) {EmptyView()}

                        NavigationLink(destination: TextsView().environmentObject(sessionService).fullBackground(), tag: 6, selection: $ID) {EmptyView()}

                        Group {
                            if sessionService.userDetails?.admin ?? false {
                                NavigationLink(destination: WorkoutView().environmentObject(sessionService), tag: 7, selection: $ID) {EmptyView()}
                            } else {
                                NavigationLink(destination: NappaliPortyaView().environmentObject(sessionService), tag: 7, selection: $ID) {EmptyView()}
                            }

                            if (sessionService.userDetails?.admin != nil) && sessionService.userDetails?.admin == true {
                                NavigationLink(destination: EjjeliPortyaAdminView().environmentObject(sessionService), tag: 8, selection: $ID) {EmptyView()}
                            } else {
                                NavigationLink(destination: EjjeliPortyaView().environmentObject(sessionService).fullBackground(), tag: 8, selection: $ID) {EmptyView()}
                            }
                        }
                        
                        if (sessionService.userDetails?.admin != nil) && sessionService.userDetails?.admin == true {
                            NavigationLink(destination: QuizAdminView(teamNum: sessionService.teamNum), tag: 9, selection: $ID) {EmptyView()}
                        } else {
                            NavigationLink(destination: QuizView().environmentObject(sessionService).fullBackground(), tag: 9, selection: $ID) {EmptyView()}
                        }
                        
                        if (sessionService.userDetails?.admin != nil) && sessionService.userDetails?.admin == true {
                            NavigationLink(destination: MultipleTextQuizAdminView().environmentObject(sessionService), tag: 10, selection: $ID) {EmptyView()}
                        } else {
                            NavigationLink(destination: MultipleTextQuizView().environmentObject(sessionService).fullBackground(), tag: 10, selection: $ID) {EmptyView()}
                        }
                    }
                    
                    //only admin buttons
                    Group {
                        NavigationLink(destination: ImagesView(checkImages: true).environmentObject(sessionService), tag: 11, selection: $ID) {EmptyView()}

                        NavigationLink(destination: AddScoreView(teamNum: sessionService.teamNum).fullBackground(), tag: 12, selection: $ID) {EmptyView()}

                        NavigationLink(destination: NotificationAdminView(), tag: 13, selection: $ID) {EmptyView()}
                        
                        NavigationLink(destination: TreasureHuntAdminView().environmentObject(sessionService), tag: 14, selection: $ID) {EmptyView()}
                    }
                }
                
                NavigationLink(destination: ProfileView().environmentObject(sessionService).fullBackground(), label: {
                    HStack {
                        Image(systemName: "person.crop.circle")
                        Text("Bejelentkezve, mint \(sessionService.userDetails?.fullName ?? "«nincs név»")")
                    }
                })
                .padding()
                .buttonStyle(SimpleButtonStyle())
            }
        }
        .navigationBarTitle("TiszApp")
        .navigationBarTitleDisplayMode(.inline)
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
