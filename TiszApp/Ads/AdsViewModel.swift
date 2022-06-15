//
//  AdsViewModel.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 06. 14..
//

import GoogleMobileAds
import SwiftUI

final class AdsViewModel: UIViewController, GADFullScreenContentDelegate, ObservableObject {
    
    @Published var rewardGiven : Bool = false
    
    @Published var canGiveReward: Bool = false
    
    private var rewardedAd: GADRewardedAd?
    
    func loadRewardedAd(root: UIViewController) {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID:"ca-app-pub-3940256099942544/1712485313",
                           request: request,
                           completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            rewardedAd = ad
            print("Rewarded ad loaded.")
            rewardedAd?.fullScreenContentDelegate = self
            self.show(root: root)
        }
        )
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
            self.rewardGiven = true
        }
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
}
