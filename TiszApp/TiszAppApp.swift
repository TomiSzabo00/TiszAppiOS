//
//  TiszAppApp.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 03. 23..
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleMobileAds

@main
struct TiszAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var sessionService = SessionServiceImpl()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                switch sessionService.state {
                case .loggedIn:
                    MainMenuView().environmentObject(sessionService)
                        .onAppear {
                            sessionService.getButtonStates()
                        }
                case .loggedOut:
                    LoginView()
                    //PredictedTextTest()
                }
            }
            .accentColor(Color.gradientDark)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
}

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}
