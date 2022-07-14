//
//  AdsViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 14..
//

import GoogleMobileAds
import SwiftUI

enum AdStatus {
    case finished
    case interrupted
    case tooManyRequests
    case cancelled
    case na
}

final class AdsViewModel: UIViewController, GADFullScreenContentDelegate, ObservableObject {
    @Published var showAlert: Bool = false
    @Published var adStatus: AdStatus = .na
    
    @Published var canGiveReward: Bool = false
    
    private var rewardedAd: GADRewardedAd?
    
    func loadRewardedAd(root: UIViewController) {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID:"ca-app-pub-7106700934170477/8368308904", request: request) { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                let errorCode = GADErrorCode(rawValue: error._code)
                switch errorCode {
                case .invalidRequest:
                    print("invalid req")
                    adStatus = .interrupted
                case .noFill:
                    print("no fill")
                    adStatus = .tooManyRequests
                case .networkError:
                    print("network err")
                    adStatus = .interrupted
                case .serverError:
                    print("server err")
                    adStatus = .interrupted
                case .timeout:
                    print("timeout")
                    adStatus = .interrupted
                case .adAlreadyUsed:
                    print("already used")
                    adStatus = .interrupted
                default:
                    print("default")
                    adStatus = .interrupted
                }
                showAlert = true
                return
            }
            rewardedAd = ad
            print("Rewarded ad loaded.")
            rewardedAd?.fullScreenContentDelegate = self
            self.show(root: root)
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        if(self.canGiveReward) {
            adStatus = .finished
        } else {
            adStatus = .cancelled
        }
        self.showAlert = true
    }
    
    func show(root: UIViewController) {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: root) {
                let reward = ad.adReward
                print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                self.canGiveReward = true
            }
        } else {
            print("Ad wasn't ready")
        }
    }

    func displayAlert() -> Alert {
        switch adStatus {
        case .finished:
            return Alert(title: Text("Reklám megnézve"),
                         message: Text("Köszönjük, hogy végignézted a reklámot. Überkiráy vagy!"),
                         dismissButton: Alert.Button.default(
                            Text("Szívesen :)"), action: { self.canGiveReward = false }
                         )
            )
        case .tooManyRequests:
            return Alert(title: Text("Reklám hiba"),
                         message: Text("10 percenként csak egy reklámot nézhetsz meg. Köszi, hogy támogatnál, de inkább menj játszani ;)"),
                         dismissButton: Alert.Button.default(
                            Text("OK"), action: { self.canGiveReward = false }
                         )
            )
        case .interrupted:
            return Alert(title: Text("Reklám hiba"),
                         message: Text("Valamilyen, valószínűleg hálózati hiba történt. Próbáld meg később."),
                         dismissButton: Alert.Button.default(
                            Text("OK"), action: { self.canGiveReward = false }
                         )
            )
        case .cancelled:
            return Alert(title: Text("Reklám megszakítva"),
                         message: Text("Túl korán kiléptél a reklámból. Így nem kapunk jutalmat :("),
                         dismissButton: Alert.Button.default(
                            Text("Bocsánat"), action: { self.canGiveReward = false }
                         )
            )
        case .na:
            return Alert(title: Text("Reklám hiba"),
                         message: Text("Ismeretlen hiba történt. Próbáld meg később."),
                         dismissButton: Alert.Button.default(
                            Text("OK"), action: { self.canGiveReward = false }
                         )
            )
        }
    }
}
