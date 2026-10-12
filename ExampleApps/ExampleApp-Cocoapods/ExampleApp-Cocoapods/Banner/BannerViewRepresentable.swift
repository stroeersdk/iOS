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
    let contentUrl: String?
    let customTargeting: [String: String]
    
    init(slotId: String, contentUrl: String? = nil, customTargeting: [String: String] = [:]) {
        self.slotId = slotId
        self.contentUrl = contentUrl
        self.customTargeting = customTargeting
    }

    func makeUIViewController(context: Context) -> BannerViewController {
        let vc = BannerViewController()
        vc.slotId = slotId
        vc.contentUrl = contentUrl
        vc.customTargeting = customTargeting
        return vc
    }

    func updateUIViewController(_ uiViewController: BannerViewController, context: Context) {
    }
}
