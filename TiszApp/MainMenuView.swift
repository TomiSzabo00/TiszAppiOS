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
                //LinearGradient(Color.gradientLight, Color.gradientDark)
                    //.mask(
                Image(systemName: self.icon)
                    .resizable()
                    .scaledToFit()
                    .padding([.leading, .trailing, .top])
                    .padding(.bottom, 10)//)
                    .frame(maxWidth: 80, maxHeight: 80)
                    //.shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 5)
                Text(self.text)
                    .bold()
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.1)
                    //.foregroundStyle(LinearGradient(Color.gradientDark, Color.gradientLight))
            }
            //.padding()
            .frame(width: min(UIScreen.main.bounds.width/2-70,UIScreen.main.bounds.height/2-70), height: min(UIScreen.main.bounds.width/2-70,UIScreen.main.bounds.height/2-70), alignment: .center)
            
        })
        //.padding()
//        .background(RoundedRectangle(cornerRadius: 10)
//            .fill(Color(.systemBackground))
//            .shadow(color: Color(.label).opacity(0.2), radius: 4, x: 0, y: 3))
        .buttonStyle(SimpleButtonStyle())
    }
}

struct MainMenuView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State var ID: Int? = nil
    
    @State var root : UIViewController!
    @StateObject var adVm = AdsViewModel()
    
    private var gridItemLayout = [GridItem(.fixed(UIScreen.main.bounds.width/2-20)), GridItem(.fixed(UIScreen.main.bounds.width/2-20))]
    
    init() {
        //Use this if NavigationBarTitle is with Large Font
        //UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.main)]

        //Use this if NavigationBarTitle is with displayMode = .inline
        //UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
    }
    
    var body: some View {
        ZStack {
            //Image("bg2_day").scaledToFit()
            VStack{
                
                ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 40) {
                        ForEach($sessionService.buttonTitles, id: \.self) { $e in
                            if(sessionService.btnStates[sessionService.buttonTitles.firstIndex(of: e) ?? 0] || sessionService.userDetails?.admin ?? false) {
                                IconButton(text: e,
                                           icon: sessionService.buttonIcons[sessionService.buttonTitles.firstIndex(of: e)!],
                                           action: { ID = sessionService.buttonTitles.firstIndex(of: e)! })
                            }

                        }
                        
                        IconButton(text: "Támogasd a fejlesztőket", icon: "dollarsign.circle.fill", action: {
                            adVm.loadRewardedAd(root: self.root)
                        })
                        .onAppear {
                            self.root = UIApplication.shared.windows.first?.rootViewController
                        }
                        .alert(isPresented: $adVm.rewardGiven, content: {
                            return Alert(title: Text("Reklám megnézve"),
                                         message: Text("Köszönjük, hogy végignézted a reklámot. Überkiráy vagy!"),
                                         dismissButton: Alert.Button.default(
                                            Text("Szívesen :)"), action: { adVm.canGiveReward = false }
                                         )
                                     )
                        })
                    } //LazyVGrid end
                    //.padding([.leading, .trailing], 20)
                    .padding([.top, .bottom])
                } //ScrollView end
                
                Group {
                    Group {
                        NavigationLink(destination: ScheduleView(), tag: 0, selection: $ID) {EmptyView()}
                        
                        NavigationLink(destination: ScoresTableView(handler: ScoresHandlerImpl(teamNum: sessionService.teamNum)).environmentObject(sessionService).fullBackground(), tag: 1, selection: $ID) {EmptyView()}

                        NavigationLink(destination: WordleView().environmentObject(sessionService).fullBackground(), tag: 2, selection: $ID) {EmptyView()}

                        NavigationLink(destination: UploadView(), tag: 3, selection: $ID) {EmptyView()}

                        NavigationLink(destination: ImagesView(checkImages: false).environmentObject(sessionService).fullBackground(), tag: 4, selection: $ID) {EmptyView()}

                        NavigationLink(destination: SongsView().fullBackground(), tag: 5, selection: $ID) {EmptyView()}

                        NavigationLink(destination: TextsView().environmentObject(sessionService).fullBackground(), tag: 6, selection: $ID) {EmptyView()}

                        Group {
                            NavigationLink(destination: NappaliPortyaView(), tag: 7, selection: $ID) {EmptyView()}

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
                    
                        NavigationLink(destination: AddScoreView(teamNum: sessionService.teamNum), tag: 12, selection: $ID) {EmptyView()}
                    
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
//                Button(action: {
//
//                    sessionService.logout()
//
//                }, label: {
//                    HStack {
//                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
//                        Text("Kijelentkezés")
//                    }
//                })
//                .padding()
                //.buttonStyle(SimpleButtonStyle())
                
            }
            //.background(Image("bg2_day").resizable().ignoresSafeArea())
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
