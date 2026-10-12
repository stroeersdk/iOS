//
//  InterstitialViewRepresentable.swift
//  AdTestApp
//
//  Created by Shafee Rehman on 01/07/2025.
//

import SwiftUI

struct InterstitialViewRepresentable: UIViewControllerRepresentable {
    let adSlotId: String
    var errorCallback: ((String) -> Void)? = nil
    var isLoaded: ((Bool) -> Void)? = nil
    
    func makeUIViewController(context: Context) -> InterstitialViewController {
        let vc = InterstitialViewController(adSlotId: adSlotId)
        vc.onError = errorCallback
        vc.isLoaded = isLoaded
        vc.loadInterstitialAd()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: InterstitialViewController, context: Context) {
    }
}
