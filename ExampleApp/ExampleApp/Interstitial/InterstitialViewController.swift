 //
//  InterstitialViewController.swift
//  AdTestApp
//
//  Created by Shafee Rehman on 01/07/2025.
//

import SwiftUI
import StroeerSDK

class InterstitialViewController: UIViewController {
    var adSlotId: String
    var delegate: InterstitialViewDelegate?
    var onError: ((String) -> Void)?
    var isLoaded: ((Bool) -> Void)?
    var interstitialView: StroeerInterstitialView?
    
    init(adSlotId: String) {
        self.adSlotId = adSlotId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadInterstitialAd() {
        self.delegate = InterstitialViewDelegate(viewController: self, errorCallback: onError, isLoaded: isLoaded)
        self.interstitialView = Stroeer.instance.interstitialAd(adSlotId: adSlotId, interstitialDelegate: delegate)
    }
    
    deinit {
        delegate = nil
    }
}
