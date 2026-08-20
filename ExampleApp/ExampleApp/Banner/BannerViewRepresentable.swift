//
//  BannerViewRepresentable.swift
//  SimpleAdTest
//
//  Created by Hyungon Kim on 22/07/2024.
//

import Foundation
import SwiftUI
import StroeerSDK


struct BannerViewRepresentable: UIViewControllerRepresentable {
    
    let slotId: String
    let onAdSize: (CGSize) -> Void

    func makeUIViewController(context: Context) -> BannerViewController {
        let vc = BannerViewController()
        vc.slotId = slotId
        vc.onAdSize = onAdSize
        return vc
    }

    func updateUIViewController(_ uiViewController: BannerViewController, context: Context) {
    }
}
